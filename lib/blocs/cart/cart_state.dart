import 'package:equatable/equatable.dart';

import '../../models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];

  @override
  String toString() =>
      'CartState(totalItems: $totalItems, totalPrice: $totalPrice)';
}