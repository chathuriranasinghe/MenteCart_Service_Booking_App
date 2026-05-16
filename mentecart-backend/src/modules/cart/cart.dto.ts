export interface AddCartItemDto {
  serviceId: string;
  selectedDate: string;
  selectedTime: string;
  quantity: number;
}

export interface UpdateCartItemDto {
  selectedDate?: string;
  selectedTime?: string;
  quantity?: number;
}

export interface CartItemResponseDto {
  itemId: string;
  serviceId: string;
  title: string;
  price: number;
  quantity: number;
  selectedDate: string;
  selectedTime: string;
  image: string;
  total: number;
}

export interface CartResponseDto {
  id: string;
  userId: string;
  items: CartItemResponseDto[];
  itemCount: number;
  subTotal: number;
  expiresAt: Date;
  createdAt: Date;
  updatedAt: Date;
}