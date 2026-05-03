import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(const ProductLoading()) {
    on<FetchAllProducts>(_onFetchAllProducts);
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
  }

  /// Handles FetchAllProducts event — called on app start
  Future<void> _onFetchAllProducts(
      FetchAllProducts event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());
    try {
      final products = await productRepository.getAllProducts();
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  /// Handles FetchProductsByCategory event — called when category chip tapped
  Future<void> _onFetchProductsByCategory(
      FetchProductsByCategory event,
      Emitter<ProductState> emit,
      ) async {
    emit(const ProductLoading());
    try {
      final products = await productRepository.getProductsByCategory(event.categoryId);
      emit(ProductLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}