export type BookingStatus =
  | 'pending'
  | 'confirmed'
  | 'completed'
  | 'cancelled'
  | 'failed';

export type PaymentMethod = 'cash' | 'card' | 'pay_on_arrival';

export type PaymentStatus = 'unpaid' | 'paid' | 'failed';

export interface CheckoutDto {
  paymentMethod: PaymentMethod;
}

export interface BookingItemResponseDto {
  serviceId: string;
  title: string;
  price: number;
  quantity: number;
  selectedDate: string;
  selectedTime: string;
  image: string;
  total: number;
}

export interface StatusHistoryEntryDto {
  status: BookingStatus;
  changedAt: Date;
}

export interface BookingResponseDto {
  id: string;
  bookingNumber: string;
  userId: string;
  items: BookingItemResponseDto[];
  totalAmount: number;
  bookingStatus: BookingStatus;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  statusHistory: StatusHistoryEntryDto[];
  cancelledAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface BookingListResponseDto {
  bookings: BookingResponseDto[];
}
