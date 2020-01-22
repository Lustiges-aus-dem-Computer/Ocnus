import '../entities/category.dart';

/// Abstract class for events to be handled by the category bloc
abstract class CategoriesEvent {}

/// Event triggering loading of categories from the remote database
class LoadCategoriesFromServer extends CategoriesEvent {}

/// Event triggering loading of categories
class LoadCategoriesFromCage extends CategoriesEvent {}

/// Evend triggering addition of a new category
class AddCategory extends CategoriesEvent {
  /// Category to be added
  final Category category;

  /// Constructor for new category event
  AddCategory(this.category);
}

/// Evend triggering updating of a category
class UpdateCategory extends CategoriesEvent {
  /// Category to be updated
  final Category category;

  /// Constructor for update category event
  UpdateCategory(this.category);
}

/// Evend triggering deletion of a category
class DeleteCategory extends CategoriesEvent {
  /// Category to be updated
  final Category category;

  /// Constructor for delete category event
  DeleteCategory(this.category);
}
