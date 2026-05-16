import { Types } from 'mongoose';

import { AppError } from '../../core/errors/app-error';
import { ServiceRepository } from '../services/service.repository';
import {
  AddCartItemDto,
  CartItemResponseDto,
  CartResponseDto,
  UpdateCartItemDto,
} from './cart.dto';
import { CartDocument } from './cart.model';
import { CartRepository } from './cart.repository';

export class CartService {
  constructor(
    private readonly cartRepository: CartRepository,
    private readonly serviceRepository: ServiceRepository,
  ) {}

  async getCart(userId: string): Promise<CartResponseDto> {
    const cart = await this.getOrCreateCart(userId);

    return this.mapCartResponse(cart);
  }

  async addItem(
    userId: string,
    payload: AddCartItemDto,
  ): Promise<CartResponseDto> {
    const service = await this.serviceRepository.findById(payload.serviceId);

    if (!service) {
      throw new AppError('Service not found', 404, 'SERVICE_NOT_FOUND');
    }

    const cart = await this.getOrCreateCart(userId);

    const existingItem = cart.items.find(
      (item) =>
        item.serviceId.toString() === payload.serviceId &&
        item.selectedDate === payload.selectedDate &&
        item.selectedTime === payload.selectedTime,
    );

    if (existingItem) {
      existingItem.quantity += payload.quantity;
    } else {
      cart.items.push({
        _id: new Types.ObjectId(),
        serviceId: new Types.ObjectId(service._id.toString()),
        title: service.title,
        price: service.price,
        quantity: payload.quantity,
        selectedDate: payload.selectedDate,
        selectedTime: payload.selectedTime,
        image: service.image,
      });
    }

    cart.expiresAt = this.cartRepository.createCartExpiryDate();

    const savedCart = await this.cartRepository.save(cart);

    return this.mapCartResponse(savedCart);
  }

  async updateItem(
    userId: string,
    itemId: string,
    payload: UpdateCartItemDto,
  ): Promise<CartResponseDto> {
    const cart = await this.getOrCreateCart(userId);

    const item = cart.items.find(
      (cartItem) => cartItem._id.toString() === itemId,
    );

    if (!item) {
      throw new AppError('Cart item not found', 404, 'CART_ITEM_NOT_FOUND');
    }

    const nextDate = payload.selectedDate ?? item.selectedDate;
    const nextTime = payload.selectedTime ?? item.selectedTime;
    const nextQuantity = payload.quantity ?? item.quantity;

    const duplicateItem = cart.items.find(
      (cartItem) =>
        cartItem._id.toString() !== itemId &&
        cartItem.serviceId.toString() === item.serviceId.toString() &&
        cartItem.selectedDate === nextDate &&
        cartItem.selectedTime === nextTime,
    );

    if (duplicateItem) {
      throw new AppError(
        'This service is already added for the selected slot',
        409,
        'SLOT_DUPLICATE',
      );
    }

    item.selectedDate = nextDate;
    item.selectedTime = nextTime;
    item.quantity = nextQuantity;
    cart.expiresAt = this.cartRepository.createCartExpiryDate();

    const savedCart = await this.cartRepository.save(cart);

    return this.mapCartResponse(savedCart);
  }

  async removeItem(userId: string, itemId: string): Promise<CartResponseDto> {
    const cart = await this.getOrCreateCart(userId);

    const initialLength = cart.items.length;

    cart.items = cart.items.filter(
      (item) => item._id.toString() !== itemId,
    ) as typeof cart.items;

    if (cart.items.length === initialLength) {
      throw new AppError('Cart item not found', 404, 'CART_ITEM_NOT_FOUND');
    }

    cart.expiresAt = this.cartRepository.createCartExpiryDate();

    const savedCart = await this.cartRepository.save(cart);

    return this.mapCartResponse(savedCart);
  }

  private async getOrCreateCart(userId: string): Promise<CartDocument> {
    const existingCart = await this.cartRepository.findByUserId(userId);

    if (existingCart) {
      return existingCart;
    }

    return this.cartRepository.createCart(
      userId,
      this.cartRepository.createCartExpiryDate(),
    );
  }

  private mapCartResponse(cart: CartDocument): CartResponseDto {
    const items: CartItemResponseDto[] = cart.items.map((item) => ({
      itemId: item._id.toString(),
      serviceId: item.serviceId.toString(),
      title: item.title,
      price: item.price,
      quantity: item.quantity,
      selectedDate: item.selectedDate,
      selectedTime: item.selectedTime,
      image: item.image,
      total: item.price * item.quantity,
    }));

    const subTotal = items.reduce((total, item) => total + item.total, 0);

    const itemCount = items.reduce(
      (total, item) => total + item.quantity,
      0,
    );

    return {
      id: cart._id.toString(),
      userId: cart.userId.toString(),
      items,
      itemCount,
      subTotal,
      expiresAt: cart.expiresAt,
      createdAt: cart.createdAt,
      updatedAt: cart.updatedAt,
    };
  }
}