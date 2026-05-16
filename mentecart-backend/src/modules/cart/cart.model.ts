import mongoose, { Document, Schema, Types } from 'mongoose';

export interface CartItem {
  _id: Types.ObjectId;
  serviceId: Types.ObjectId;
  title: string;
  price: number;
  quantity: number;
  selectedDate: string;
  selectedTime: string;
  image: string;
}

export interface CartDocument extends Document {
  userId: Types.ObjectId;
  items: CartItem[];
  expiresAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

const cartItemSchema = new Schema<CartItem>(
  {
    serviceId: {
      type: Schema.Types.ObjectId,
      ref: 'Service',
      required: true,
    },
    title: {
      type: String,
      required: true,
      trim: true,
    },
    price: {
      type: Number,
      required: true,
      min: 0,
    },
    quantity: {
      type: Number,
      required: true,
      min: 1,
      default: 1,
    },
    selectedDate: {
      type: String,
      required: true,
    },
    selectedTime: {
      type: String,
      required: true,
    },
    image: {
      type: String,
      required: true,
    },
  },
  {
    _id: true,
  },
);

const cartSchema = new Schema<CartDocument>(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
      index: true,
    },
    items: {
      type: [cartItemSchema],
      default: [],
    },
    expiresAt: {
      type: Date,
      required: true,
    },
  },
  {
    timestamps: true,
  },
);

cartSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

export const CartModel = mongoose.model<CartDocument>('Cart', cartSchema);