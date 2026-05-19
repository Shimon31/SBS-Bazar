import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final int productId;

  const RemoveFromCart(this.productId);

  @override
  List<Object?> get props => [productId];
}

class IncrementQuantity extends CartEvent {
  final int productId;

  const IncrementQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class DecrementQuantity extends CartEvent {
  final int productId;

  const DecrementQuantity(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}