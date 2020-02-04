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
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'black',
      title: 'Local',
      icon: 'blender',
      location: 'Local',
    );
    var testCatRemote = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'black',
      title: 'Remote',
      icon: 'blender',
      location: 'Remote',
    );
    var testCatRemoteUpdate = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'black',
      title: 'Update',
      icon: 'blender',
      location: 'Remote',
    );
    var testItemLocal = Item(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        title: 'Local',
        size: 'L',
        type: 'm',
        description: 'This is a test-item',
        images: [],
        categoryId: testCatLocal.id
    );
    var testItemRemote = Item(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        title: 'Remote',
        size: 'L',
        type: 'm',
        description: 'This is a test-item',
        images: [],
        categoryId: testCatRemote.id
    );

    testCatRemoteUpdate = testCatRemote.copyWith();

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putCategories([testCatLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getCategories())
      .thenAnswer((_) => Future.value([testCatLocal]));

    when(mockManagerLocal.deleteCategories([testCatLocal.id]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getItems())
        .thenAnswer((_) => Future.value([testItemLocal, testItemRemote]));

    var mockManagerLocalError= MockManager();
    when(mockManagerLocalError.putCategories([testCatLocal]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.putCategories([testCatRemote]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.putCategories([testCatRemoteUpdate]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.getCategories())
        .thenAnswer((_) => Future.value([testCatLocal]));

    when(mockManagerLocalError.deleteCategories([testCatLocal.id]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.deleteCategories([testCatRemote.id]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.getItems())
        .thenAnswer((_) => Future.value([testItemLocal, testItemRemote]));


    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putCategories([testCatRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getCategories())
    .thenAnswer((_) => Future.value([testCatRemote]));

    var _catRepLocalError =
    Repository(localDatabaseManager: mockManagerLocalError);
    var _catRepLocal = 
    Repository(localDatabaseManager: mockManagerLocal);
    var _catRepRemote =
    Repository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => CategoryBlock(repository: _catRepLocal),
    expect: [CategoriesLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => CategoryBlock(repository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategoriesFromCage()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal])],
    );

    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => CategoryBlock(repository: _catRepRemote),
    act: (bloc) => bloc.add(LoadCategoriesFromCage()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => CategoryBlock(repository: _catRepRemote),
    act: (bloc) => bloc.add(LoadCategoriesFromServer()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => CategoryBlock(repository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategoriesFromServer()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Add Category -> Loaded',
    build: () => CategoryBlock(repository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote])],
    );

    blocTest(
      'Add Category -> Failed',
      build: () => CategoryBlock(repository: _catRepLocalError),
      act: (bloc){
        bloc.add(LoadCategoriesFromCage());
        bloc.add(AddCategory(testCatRemote));
        return;
      },
      expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]),
        CategoriesUpdateFailed()],
    );

    blocTest(
    'Update Category -> Loaded',
    build: () => CategoryBlock(repository: _catRepLocal),
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

    blocTest(
    'Update Category -> Failed',
    build: () => CategoryBlock(repository: _catRepLocalError),
    act: (bloc){
    bloc.add(LoadCategoriesFromCage());
    bloc.add(UpdateCategory(testCatRemoteUpdate));
    return;
    },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]),
    CategoriesUpdateFailed()],
    );

    blocTest(
    'Delete Category -> Loaded',
    build: () => CategoryBlock(repository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategoriesFromCage());
      bloc.add(AddCategory(testCatRemote));
      bloc.add(DeleteCategory(testCatRemote));
      return;
      },
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]), 
    CategoriesLoaded([testCatLocal, testCatRemote]),
    CategoriesLoaded([testCatLocal])],
    );

    blocTest(
      'Delete Category -> Failed',
      build: () => CategoryBlock(repository: _catRepLocalError),
      act: (bloc){
        bloc.add(LoadCategoriesFromCage());
        bloc.add(DeleteCategory(testCatLocal));
        return;
      },
      expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]),
        CategoriesUpdateFailed()],
    );
  });
}

