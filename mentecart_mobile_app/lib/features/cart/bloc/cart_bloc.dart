import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<CartFetchRequested>(_onFetch);
    on<CartItemIncrementRequested>(_onIncrement);
    on<CartItemDecrementRequested>(_onDecrement);
    on<CartItemRemoveRequested>(_onRemove);
  }

  Future<void> _onFetch(
    CartFetchRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final data = await CartRepository.getCart();
      emit(CartLoaded(_parseItems(data)));
    } catch (_) {
      emit(CartLoaded([]));
    }
  }

  Future<void> _onIncrement(
    CartItemIncrementRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = _currentItems;
    try {
      final data = await CartRepository.updateItem(
        event.itemId,
        quantity: event.currentQuantity + 1,
      );
      emit(CartLoaded(_parseItems(data)));
    } on DioException catch (e) {
      emit(
        CartActionFailure(
          e.response?.data?['message'] ?? 'Update failed',
          current,
        ),
      );
      emit(CartLoaded(current));
    }
  }

  Future<void> _onDecrement(
    CartItemDecrementRequested event,
    Emitter<CartState> emit,
  ) async {
    if (event.currentQuantity <= 1) return;
    final current = _currentItems;
    try {
      final data = await CartRepository.updateItem(
        event.itemId,
        quantity: event.currentQuantity - 1,
      );
      emit(CartLoaded(_parseItems(data)));
    } on DioException catch (e) {
      emit(
        CartActionFailure(
          e.response?.data?['message'] ?? 'Update failed',
          current,
        ),
      );
      emit(CartLoaded(current));
    }
  }

  Future<void> _onRemove(
    CartItemRemoveRequested event,
    Emitter<CartState> emit,
  ) async {
    final current = _currentItems;
    try {
      await CartRepository.removeItem(event.itemId);
      final updated = current.where((i) => i.id != event.itemId).toList();
      emit(CartLoaded(updated));
    } on DioException catch (e) {
      emit(
        CartActionFailure(
          e.response?.data?['message'] ?? 'Remove failed',
          current,
        ),
      );
      emit(CartLoaded(current));
    }
  }

  List<CartItemData> get _currentItems =>
      state is CartLoaded ? (state as CartLoaded).items : [];

  List<CartItemData> _parseItems(Map<String, dynamic> data) {
    final items = data['items'] as List<dynamic>;
    return items
        .map(
          (i) => CartItemData(
            id: i['itemId'] as String,
            title: i['title'] as String,
            dateTime: '${i['selectedDate']}, ${i['selectedTime']}',
            unitPrice: (i['price'] as num).toInt(),
            quantity: (i['quantity'] as num).toInt(),
            imageUrl: i['image'] as String,
          ),
        )
        .toList();
  }
}
