import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app start — fetches all products
class FetchAllProducts extends ProductEvent {
  const FetchAllProducts();
}

/// Fired when user taps a category chip — fetches filtered products
class FetchProductsByCategory extends ProductEvent {
  final int categoryId;

  const FetchProductsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}