part of 'cart_bloc.dart';

abstract class CartEvent {}

class CartFetchRequested extends CartEvent {}

class CartItemIncrementRequested extends CartEvent {
  CartItemIncrementRequested(this.itemId, this.currentQuantity);
  final String itemId;
  final int currentQuantity;
}

class CartItemDecrementRequested extends CartEvent {
  CartItemDecrementRequested(this.itemId, this.currentQuantity);
  final String itemId;
  final int currentQuantity;
}

class CartItemRemoveRequested extends CartEvent {
  CartItemRemoveRequested(this.itemId);
  final String itemId;
}
