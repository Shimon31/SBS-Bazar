import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/category_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository})
      : super(const CategoryLoading()) {
    on<FetchCategories>(_onFetchCategories);
    on<SelectCategory>(_onSelectCategory);
  }

  /// Fetches all categories from API on app start
  Future<void> _onFetchCategories(
      FetchCategories event,
      Emitter<CategoryState> emit,
      ) async {
    emit(const CategoryLoading());
    try {
      final categories = await categoryRepository.getAllCategories();
      // Start with no category selected (shows "All" by default)
      emit(CategoryLoaded(categories: categories, selectedCategoryId: null));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  /// Updates the selected category chip without re-fetching categories
  void _onSelectCategory(
      SelectCategory event,
      Emitter<CategoryState> emit,
      ) {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      emit(currentState.copyWith(
        // If same chip tapped again → deselect (show All)
        selectedCategoryId: event.categoryId == currentState.selectedCategoryId
            ? null
            : event.categoryId,
        clearSelected: event.categoryId == currentState.selectedCategoryId,
      ));
    }
  }
}