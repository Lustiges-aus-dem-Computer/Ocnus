import 'category.dart';

/// Abstract class for events to be handled by the category bloc
abstract class CategoriesEvent {}

/// Event triggering loading of categories
class LoadCategories extends CategoriesEvent {}

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

/// Event to mark a category for deletion
class DeleteCategory extends CategoriesEvent {
  /// Category to be marked for deletion
  final Category category;

  /// Constructor for delete category event
  DeleteCategory(this.category);
}
