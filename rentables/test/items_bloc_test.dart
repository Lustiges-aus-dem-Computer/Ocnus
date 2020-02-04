import 'package:bloc_test/bloc_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:rentables/rentables.dart';
import 'package:rentables/src/blocs/items_bloc.dart';
import 'package:rentables/src/blocs/items_events.dart';

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  group('Items Bloc tests', (){
    Logger.level = Level.debug;

    var testCatLocal = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'black',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testCatRemote = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'white',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
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
    var testItemLocalUpdate = Item(
        created: DateTime.now(),
        modified: DateTime.now(),
        id: LocalIdGenerator().getId(),
        title: 'Update',
        size: 'L',
        type: 'm',
        description: 'This is a test-item',
        images: [],
        categoryId: testCatRemote.id
    );
    testItemLocalUpdate = testItemLocal.copyWith();

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putItems([testItemLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getItems([testItemLocal.id]))
      .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocal.getItems())
      .thenAnswer((_) => Future.value([testItemLocal]));

    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putItems([testItemRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getItems([testItemRemote.id]))
    .thenAnswer((_) => Future.value([testItemRemote]));

    var mockManagerLocalError= MockManager();
    when(mockManagerLocalError.putItems([testItemLocal]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.putItems([testItemRemote]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.putItems([testItemLocalUpdate]))
        .thenAnswer((_) => throw Exception('Error'));

    when(mockManagerLocalError.getItems([testItemLocal.id]))
        .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocalError.deleteReservations(testItemLocal.reservations))
        .thenAnswer((_) => Future.value(null));

    when(mockManagerLocalError.deleteItems([testItemLocal.id]))
        .thenAnswer((_) => throw Exception('Error'));

    var _itemRepLocalError =
    Repository(localDatabaseManager: mockManagerLocalError);
    var _itmRepLocal = 
    Repository(localDatabaseManager: mockManagerLocal);
    var _itmRepRemote =
    Repository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => ItemBloc(repository: _itmRepLocal),
    expect: [ItemsLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItemsFromCage([testItemLocal.id])),
    expect: [ItemsLoading(), ItemsLoaded([testItemLocal])],
    );
    
    blocTest(
    'Loading Search Terms -> Search Terms Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItemSearchParameters()),
    expect: [ItemsLoading(), ItemsSearchParametersLoaded({testItemLocal.id: 
    {searchParameters.category: testItemLocal.categoryId,
     searchParameters.searchTerm: 
     '${testItemLocal.title} ${testItemLocal.description}'}})],
    );

    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => ItemBloc(repository: _itmRepRemote),
    act: (bloc) => bloc.add(LoadItemsFromCage([testItemRemote.id])),
    expect: [ItemsLoading(), ItemsNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => ItemBloc(repository: _itmRepRemote),
    act: (bloc) => bloc.add(LoadItemsFromServer([testItemRemote.id])),
    expect: [ItemsLoading(), ItemsLoaded([testItemRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItemsFromServer([testItemLocal.id])),
    expect: [ItemsLoading(), ItemsNotLoaded()],
    );

    blocTest(
    'Add Item -> Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc){
      bloc.add(LoadItemsFromCage([testItemLocal.id]));
      bloc.add(AddItem(testItemRemote));
      return;
      },
    expect: [ItemsLoading(), ItemsLoaded([testItemLocal]), 
    ItemsLoaded([testItemLocal, testItemRemote])],
    );

    blocTest(
      'Add Item -> Failed',
      build: () => ItemBloc(repository: _itemRepLocalError),
      act: (bloc){
        bloc.add(LoadItemsFromCage([testItemLocal.id]));
        bloc.add(AddItem(testItemRemote));
        return;
      },
      expect: [ItemsLoading(), ItemsLoaded([testItemLocal]),
        ItemsUpdateFailed()],
    );

    blocTest(
    'Update Item -> Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc){
      bloc.add(LoadItemsFromCage([testItemLocal.id]));
      bloc.add(AddItem(testItemRemote));
      bloc.add(UpdateItem(testItemLocalUpdate));
      return;
      },
    expect: [ItemsLoading(), ItemsLoaded([testItemLocal]), 
    ItemsLoaded([testItemLocal, testItemRemote]),
    ItemsLoaded([testItemLocalUpdate, testItemRemote])],
    );

    blocTest(
      'Update Item -> Failed',
      build: () => ItemBloc(repository: _itemRepLocalError),
      act: (bloc){
        bloc.add(LoadItemsFromCage([testItemLocal.id]));
        bloc.add(UpdateItem(testItemLocalUpdate));
        return;
      },
      expect: [ItemsLoading(), ItemsLoaded([testItemLocal]),
        ItemsUpdateFailed()],
    );

    blocTest(
    'Delete Item -> Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc){
      bloc.add(LoadItemsFromCage([testItemLocal.id]));
      bloc.add(AddItem(testItemRemote));
      bloc.add(DeleteItem(testItemLocal));
      return;
      },
    expect: [ItemsLoading(), ItemsLoaded([testItemLocal]), 
    ItemsLoaded([testItemLocal, testItemRemote]), 
    ItemsLoaded([testItemRemote])],
    );

    blocTest(
      'Delete Item -> Failed',
      build: () => ItemBloc(repository: _itemRepLocalError),
      act: (bloc){
        bloc.add(LoadItemsFromCage([testItemLocal.id]));
        bloc.add(DeleteItem(testItemLocal));
        return;
      },
      expect: [ItemsLoading(), ItemsLoaded([testItemLocal]),
        ItemsUpdateFailed()],
    );
  });
}

