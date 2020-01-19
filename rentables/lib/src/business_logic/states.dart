import 'category.dart';

/// Abstract class for possible category states
abstract class CategoriesState {}

/// State for when catefories are loading
class CategoriesLoading extends CategoriesState {}

/// State for when categories have been loaded
class CategoriesLoaded extends CategoriesState {
  /// List of categories that have been loaded
  final List<Category> categoriesList;

  /// Constructor initializing an emply categories list
  CategoriesLoaded([this.categoriesList = const []]);
}

/// State for when categories have not been loaded
class CategoriesNotLoaded extends CategoriesState {}
