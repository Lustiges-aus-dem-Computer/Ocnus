import 'category.dart';

abstract class CategoriesState {
  const CategoriesState();
}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categoriesList;

  const CategoriesLoaded([this.categoriesList = const []]);
}

class CategoriesNotLoaded extends CategoriesState {}