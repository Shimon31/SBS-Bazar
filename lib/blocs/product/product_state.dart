import 'package:equatable/equatable.dart';

import '../../models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial / fetching state — show shimmer or spinner
class ProductLoading extends ProductState {
  const ProductLoading();
}

/// Products fetched successfully
class ProductLoaded extends ProductState {
  final List<Product> products;

  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

/// Something went wrong
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}