import 'package:bloc_test/bloc_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:rentables/rentables.dart';

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  group('Category Bloc tests', (){
    Logger.level = Level.debug;

    var testCatLocal = Category(
      color: 'black',
      title: 'Local',
      icon: 'blender',
      location: 'Local',
    );
    var testCatRemote = Category(
      color: 'black',
      title: 'Remote',
      icon: 'blender',
      location: 'Remote',
    );
    var testCatRemoteUpdate = Category(
      color: 'black',
      title: 'Update',
      icon: 'blender',
      location: 'Remote',
    );
    testCatRemoteUpdate.id = testCatRemote.id;

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putCategories([testCatLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getCategories())
      .thenAnswer((_) => Future.value([testCatLocal]));

    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putCategories([testCatRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getCategories())
    .thenAnswer((_) => Future.value([testCatRemote]));

    var _catRepLocal = 
    CategoryRepository(localDatabaseManager: mockManagerLocal);
    var _catRepRemote = 
    CategoryRepository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    expect: [CategoriesLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategoriesFromCage()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal])],
    );

    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => CategoryBlock(categoryRepository: _catRepRemote),
    act: (bloc) => bloc.add(LoadCategoriesFromCage()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepRemote),
    act: (bloc) => bloc.add(LoadCategoriesFromServer()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategoriesFromServer()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Add Category -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote])],
    );

    blocTest(
    'Update Category -> Loaded',
    build: () => CategoryBlock(categoryRepository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      bloc.add(UpdateCategory(testCatRemoteUpdate));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote]),
    CategoriesLoaded([testCatLocal, testCatRemoteUpdate])],
    );
  });
}