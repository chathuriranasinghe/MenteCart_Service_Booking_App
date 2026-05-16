import mongoose, { Document, Schema, Types } from 'mongoose';

export type BookingStatus =
  | 'pending'
  | 'confirmed'
  | 'completed'
  | 'cancelled'
  | 'failed';

export type PaymentMethod = 'cash' | 'card' | 'pay_on_arrival';

export type PaymentStatus = 'unpaid' | 'paid' | 'failed';

export interface BookingItem {
  serviceId: Types.ObjectId;
  title: string;
  price: number;
  quantity: number;
  selectedDate: string;
  selectedTime: string;
  image: string;
}

export interface StatusHistoryEntry {
  status: BookingStatus;
  changedAt: Date;
}

export interface BookingDocument extends Document {
  bookingNumber: string;
  userId: Types.ObjectId;
  items: BookingItem[];
  totalAmount: number;
  bookingStatus: BookingStatus;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  payhereOrderId?: string;
  statusHistory: StatusHistoryEntry[];
  cancelledAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const statusHistorySchema = new Schema<StatusHistoryEntry>(
  {
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'completed', 'cancelled', 'failed'],
      required: true,
    },
    changedAt: { type: Date, required: true },
  },
  { _id: false },
);

const bookingItemSchema = new Schema<BookingItem>(
  {
    serviceId: { type: Schema.Types.ObjectId, ref: 'Service', required: true },
    title: { type: String, required: true, trim: true },
    price: { type: Number, required: true, min: 0 },
    quantity: { type: Number, required: true, min: 1 },
    selectedDate: { type: String, required: true },
    selectedTime: { type: String, required: true },
    image: { type: String, required: true },
  },
  { _id: false },
);

const bookingSchema = new Schema<BookingDocument>(
  {
    bookingNumber: { type: String, required: true, unique: true, index: true },
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    items: { type: [bookingItemSchema], required: true, default: [] },
    totalAmount: { type: Number, required: true, min: 0 },
    bookingStatus: {
      type: String,
      enum: ['pending', 'confirmed', 'completed', 'cancelled', 'failed'],
      default: 'confirmed',
      index: true,
    },
    paymentMethod: {
      type: String,
      enum: ['cash', 'card', 'pay_on_arrival'],
      required: true,
    },
    paymentStatus: {
      type: String,
      enum: ['unpaid', 'paid', 'failed'],
      default: 'unpaid',
    },
    payhereOrderId: { type: String, index: true, sparse: true },
    statusHistory: { type: [statusHistorySchema], default: [] },
    cancelledAt: { type: Date },
  },
  { timestamps: true },
);

export const BookingModel = mongoose.model<BookingDocument>('Booking', bookingSchema);
