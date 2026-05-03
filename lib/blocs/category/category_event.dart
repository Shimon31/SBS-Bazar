import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Fired on app start — loads all categories for the filter chips
class FetchCategories extends CategoryEvent {
  const FetchCategories();
}

/// Fired when user taps a category chip — tracks which is selected
class SelectCategory extends CategoryEvent {
  /// Pass null to represent "All" (no filter)
  final int? categoryId;

  const SelectCategory(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}