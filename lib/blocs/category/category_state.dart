import 'package:equatable/equatable.dart';

import '../../models/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryLoading extends CategoryState {
  const CategoryLoading();
}


class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final int? selectedCategoryId;

  const CategoryLoaded({
    required this.categories,
    this.selectedCategoryId,
  });

  CategoryLoaded copyWith({
    List<Category>? categories,
    int? selectedCategoryId,
    bool clearSelected = false,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      selectedCategoryId:
      clearSelected ? null : selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [categories, selectedCategoryId];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}