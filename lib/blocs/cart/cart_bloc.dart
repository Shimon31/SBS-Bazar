import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<IncrementQuantity>(_onIncrementQuantity);
    on<DecrementQuantity>(_onDecrementQuantity);
    on<ClearCart>(_onClearCart);
  }

  /// Adds product to cart — increments quantity if already exists
  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);
    final existingIndex =
    currentItems.indexWhere((i) => i.product.id == event.product.id);

    if (existingIndex >= 0) {
      // Already in cart — just bump the quantity
      currentItems[existingIndex] = currentItems[existingIndex].copyWith(
        quantity: currentItems[existingIndex].quantity + 1,
      );
    } else {
      // New item — add with quantity 1
      currentItems.add(CartItem(product: event.product, quantity: 1));
    }

    emit(state.copyWith(items: currentItems));
  }

  /// Removes a product completely from cart
  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    final updatedItems = state.items
        .where((i) => i.product.id != event.productId)
        .toList();
    emit(state.copyWith(items: updatedItems));
  }

  /// Increments quantity of a cart item by 1
  void _onIncrementQuantity(IncrementQuantity event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);
    final index =
    currentItems.indexWhere((i) => i.product.id == event.productId);

    if (index >= 0) {
      currentItems[index] = currentItems[index].copyWith(
        quantity: currentItems[index].quantity + 1,
      );
      emit(state.copyWith(items: currentItems));
    }
  }

  /// Decrements quantity by 1 — removes item if quantity reaches 0
  void _onDecrementQuantity(DecrementQuantity event, Emitter<CartState> emit) {
    final currentItems = List<CartItem>.from(state.items);
    final index =
    currentItems.indexWhere((i) => i.product.id == event.productId);

    if (index >= 0) {
      if (currentItems[index].quantity <= 1) {
        // Remove item entirely when quantity hits 0
        currentItems.removeAt(index);
      } else {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity - 1,
        );
      }
      emit(state.copyWith(items: currentItems));
    }
  }

  /// Clears all items from cart
  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartState());
  }
}