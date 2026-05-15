export interface ServiceQueryDto {
  page: number;
  limit: number;
  category?: string;
  search?: string;
}

export interface ServiceResponseDto {
  id: string;
  title: string;
  description: string;
  price: number;
  duration: number;
  category: string;
  image: string;
  capacityPerSlot: number;
  isActive: boolean;
  availableSlots?: AvailableSlotDto[];
  createdAt: Date;
  updatedAt: Date;
}

export interface AvailableSlotDto {
  date: string;
  time: string;
  remainingCapacity: number;
}

export interface PaginatedServicesResponseDto {
  services: ServiceResponseDto[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    hasMore: boolean;
  };
}