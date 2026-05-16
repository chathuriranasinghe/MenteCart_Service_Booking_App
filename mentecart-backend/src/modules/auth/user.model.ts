import mongoose, { Document, Schema } from 'mongoose';

export interface UserDocument extends Document {
  fullName: string;
  email: string;
  phoneNumber: string;
  password: string;
  address?: {
    label: string;
    line: string;
    phone: string;
  };
  createdAt: Date;
  updatedAt: Date;
}

const userSchema = new Schema<UserDocument>(
  {
    fullName: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    phoneNumber: {
      type: String,
      required: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
      select: true,
    },
    address: {
      label: { type: String, trim: true },
      line: { type: String, trim: true },
      phone: { type: String, trim: true },
    },
  },
  {
    timestamps: true,
  },
);

export const UserModel = mongoose.model<UserDocument>('User', userSchema);