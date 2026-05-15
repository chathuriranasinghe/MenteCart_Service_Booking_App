import mongoose, { Document, Schema } from 'mongoose';

export interface AvailableSlot {
  date: string;
  time: string;
  remainingCapacity: number;
}

export interface ServiceDocument extends Document {
  title: string;
  description: string;
  price: number;
  duration: number;
  category: string;
  image: string;
  capacityPerSlot: number;
  availableSlots: AvailableSlot[];
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const availableSlotSchema = new Schema<AvailableSlot>(
  {
    date: {
      type: String,
      required: true,
    },
    time: {
      type: String,
      required: true,
    },
    remainingCapacity: {
      type: Number,
      required: true,
      min: 0,
    },
  },
  {
    _id: false,
  },
);

const serviceSchema = new Schema<ServiceDocument>(
  {
    title: {
      type: String,
      required: true,
      trim: true,
      index: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    price: {
      type: Number,
      required: true,
      min: 0,
    },
    duration: {
      type: Number,
      required: true,
      min: 1,
    },
    category: {
      type: String,
      required: true,
      trim: true,
      index: true,
    },
    image: {
      type: String,
      required: true,
    },
    capacityPerSlot: {
      type: Number,
      required: true,
      min: 1,
    },
    availableSlots: {
      type: [availableSlotSchema],
      default: [],
    },
    isActive: {
      type: Boolean,
      default: true,
      index: true,
    },
  },
  {
    timestamps: true,
  },
);

serviceSchema.index({
  title: 'text',
  description: 'text',
  category: 'text',
});

export const ServiceModel = mongoose.model<ServiceDocument>(
  'Service',
  serviceSchema,
);