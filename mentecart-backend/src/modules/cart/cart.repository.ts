import { Types } from 'mongoose';

import { CartDocument, CartModel } from './cart.model';

export class CartRepository {
  async findByUserId(userId: string): Promise<CartDocument | null> {
    return CartModel.findOne({
      userId: new Types.ObjectId(userId),
    });
  }

  async createCart(userId: string, expiresAt: Date): Promise<CartDocument> {
    return CartModel.create({
      userId: new Types.ObjectId(userId),
      items: [],
      expiresAt,
    });
  }

  async save(cart: CartDocument): Promise<CartDocument> {
    return cart.save();
  }

  async clearCart(userId: string): Promise<void> {
    await CartModel.updateOne(
      {
        userId: new Types.ObjectId(userId),
      },
      {
        $set: {
          items: [],
          expiresAt: this.createCartExpiryDate(),
        },
      },
    );
  }

  createCartExpiryDate(): Date {
    const expiryMinutes = 15;
    return new Date(Date.now() + expiryMinutes * 60 * 1000);
  }
}