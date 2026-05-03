import 'package:equatable/equatable.dart';

import '../../models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  /// Total number of individual items (sum of all quantities)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  /// Grand total price of all items in cart
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Returns a copy of state with a new items list
  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];

  @override
  String toString() =>
      'CartState(totalItems: $totalItems, totalPrice: $totalPrice)';
}