import 'product_model.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  /// Total price for this cart item (price × quantity)
  double get totalPrice => product.price * quantity;

  /// Returns a copy of this CartItem with updated fields
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CartItem &&
              runtimeType == other.runtimeType &&
              product.id == other.product.id;

  @override
  int get hashCode => product.id.hashCode;

  @override
  String toString() =>
      'CartItem(productId: ${product.id}, quantity: $quantity, totalPrice: $totalPrice)';
}