import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rentables.dart';
export 'states.dart';

/// Bloc element (https://bloclibrary.dev/#/) for handling categories
class CategoryBlock extends Bloc<CategoriesEvent, CategoriesState>{
  /// Repository managing the database interactions for categories
  final CategoryRepository categoryRepository;

  /// Constructor for the category bloc element
  CategoryBlock({@required this.categoryRepository});

  /// Initially, categories are still being loaded
  @override
  CategoriesState get initialState => CategoriesLoading();

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async*{
    /// Cannot use switch due to type mismatch
    if(event is LoadCategoriesFromCage){
      yield* _mapLoadCategoriesToState(remote: false);
    }
    else if(event is LoadCategoriesFromServer){
      yield* _mapLoadCategoriesToState(remote: true);
    }
    else if(event is AddCategory){
      yield* _mapAddCategoryToState(event.category);
    }
    else if(event is UpdateCategory){
      yield* _mapUpdateCategoryToState(event.category);
    }
    else if(event is DeleteCategory){
      yield* _mapDeleteCategoryToState(event.category);
    }
  }

  Stream<CategoriesState> _mapLoadCategoriesToState({bool remote}) async* {
    try {
      final categories = 
      await categoryRepository.loadCategories(remote: remote);
      yield CategoriesLoaded(categories);
    }
    /// In case we have no valid cage
    on Exception catch (_) {
      yield CategoriesNotLoaded();
    }
  }

  Stream<CategoriesState> _mapAddCategoryToState(Category _category) async* {
    if (state is CategoriesLoaded) {
      /// Cascade notation
      /// List.from is needed to create a new object
      /// and not alter the state
      final _newCategories = 
      List<Category>.from((state as CategoriesLoaded).categoriesList)
        ..add(_category);
      yield CategoriesLoaded(_newCategories);
      /// Save updated list to cage and server (if available)
      categoryRepository.saveCategories([_category]);
    }
  }

  Stream<CategoriesState> _mapUpdateCategoryToState(Category _category) async* {
    if (state is CategoriesLoaded) {
      final _newCategories 
      = List<Category>.from(
        (state as CategoriesLoaded).categoriesList.map((_catTmp) =>
        _catTmp.id == _category.id ? _category : _catTmp
        ));
      yield CategoriesLoaded(_newCategories);
      /// Save updated list to cage and server (if available)
      categoryRepository.saveCategories([_category]);
    }
  }

  Stream<CategoriesState> _mapDeleteCategoryToState(Category _category) async* {
    if (state is CategoriesLoaded) {
      final _newCategories 
      = List<Category>.from(
        (state as CategoriesLoaded).categoriesList.where(
          (_catTmp) => _catTmp.id != _category.id
        ));
      yield CategoriesLoaded(_newCategories);
      /// Delete category from cage and server (if available)
      categoryRepository.deleteCategories([_category.id]);
    }
  }
}