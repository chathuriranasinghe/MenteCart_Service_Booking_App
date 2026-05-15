export interface RegisterDto {
  fullName: string;
  email: string;
  phoneNumber: string;
  password: string;
}

export interface LoginDto {
  email: string;
  password: string;
}

export interface AuthUserResponseDto {
  id: string;
  fullName: string;
  email: string;
  phoneNumber: string;
}

export interface LoginResponseDto {
  token: string;
  user: AuthUserResponseDto;
}