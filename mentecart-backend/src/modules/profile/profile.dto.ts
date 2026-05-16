export interface UpdateProfileDto {
  fullName?: string;
  phoneNumber?: string;
  address?: {
    label?: string;
    line?: string;
    phone?: string;
  };
}

export interface ProfileResponseDto {
  id: string;
  fullName: string;
  email: string;
  phoneNumber: string;
  address?: {
    label: string;
    line: string;
    phone: string;
  };
  createdAt: Date;
  updatedAt: Date;
}
