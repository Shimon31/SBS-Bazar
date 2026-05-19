import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllProducts extends ProductEvent {
  const FetchAllProducts();
}

class FetchProductsByCategory extends ProductEvent {
  final int categoryId;

  const FetchProductsByCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}