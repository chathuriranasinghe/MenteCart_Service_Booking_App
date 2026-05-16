part of 'cart_bloc.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  CartLoaded(this.items);
  final List<CartItemData> items;

  int get subTotal => items.fold(0, (t, i) => t + i.totalPrice);
}

class CartActionFailure extends CartState {
  CartActionFailure(this.message, this.previousItems);
  final String message;
  final List<CartItemData> previousItems;
}

class CartItemData {
  const CartItemData({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String dateTime;
  final int unitPrice;
  final int quantity;
  final String imageUrl;

  int get totalPrice => unitPrice * quantity;

  CartItemData copyWith({int? quantity}) => CartItemData(
        id: id,
        title: title,
        dateTime: dateTime,
        unitPrice: unitPrice,
        quantity: quantity ?? this.quantity,
        imageUrl: imageUrl,
      );
}
