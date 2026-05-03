import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Add a product to cart — if already exists, increments quantity
class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

/// Remove a product from cart completely regardless of quantity
class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Increment quantity of an existing cart item by 1
class IncrementQuantity extends CartEvent {
  final int productId;

  const IncrementQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Decrement quantity by 1 — removes item if quantity reaches 0
class DecrementQuantity extends CartEvent {
  final int productId;

  const DecrementQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

/// Clears all items from the cart
class ClearCart extends CartEvent {
  const ClearCart();
}