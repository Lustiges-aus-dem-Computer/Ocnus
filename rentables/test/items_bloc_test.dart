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
      color: 'black',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testCatRemote = Category(
      color: 'white',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testItemLocal = Item(
      title: 'Local',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      thumbnailLink: 'http:://api_request',
      category: testCatLocal
    );
    var testItemRemote = Item(
      title: 'Remote',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      thumbnailLink: 'http:://api_request',
      category: testCatRemote
    );
    var testItemLocalUpdate = Item(
      title: 'Update',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      thumbnailLink: 'http:://api_request',
      category: testCatLocal
    );
    testItemLocalUpdate.id = testItemLocal.id;
    testItemLocalUpdate.update();

    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putItems([testItemLocal]))
      .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getItems(idList: [testItemLocal.id]))
      .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocal.getItems())
      .thenAnswer((_) => Future.value([testItemLocal]));

    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putItems([testItemRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getItems(idList: [testItemRemote.id]))
    .thenAnswer((_) => Future.value([testItemRemote]));

    var _itmRepLocal = 
    ItemRepository(localDatabaseManager: mockManagerLocal);
    var _itmRepRemote = 
    ItemRepository(remoteDatabaseManager: mockManagerRemote);

    blocTest(
    'Initialize Bloc',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
    expect: [ItemsLoading()],
    );

    blocTest(
    'Loading from Cage -> Loaded',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItemsFromCage([testItemLocal.id])),
    expect: [ItemsLoading(), ItemsLoaded([testItemLocal])],
    );
    
    blocTest(
    'Loading Search Terms -> Search Terms Loaded',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItemSearchParameters()),
    expect: [ItemsLoading(), ItemsSearchParametersLoaded({testItemLocal.id: 
    {searchParameters.category: testItemLocal.categoryId,
     searchParameters.searchTerm: 
     '${testItemLocal.title} ${testItemLocal.description}'}})],
    );

    blocTest(
    'Loading from Cage -> Loaded - Error',
    build: () => ItemBloc(itemRepository: _itmRepRemote),
    act: (bloc) => bloc.add(LoadItemsFromCage([testItemRemote.id])),
    expect: [ItemsLoading(), ItemsNotLoaded()],
    );

    blocTest(
    'Loading from Server -> Loaded',
    build: () => ItemBloc(itemRepository: _itmRepRemote),
    act: (bloc) => bloc.add(LoadItemsFromServer([testItemRemote.id])),
    expect: [ItemsLoading(), ItemsLoaded([testItemRemote])],
    );

    blocTest(
    'Loading from Server -> Loaded - Error',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItemsFromServer([testItemLocal.id])),
    expect: [ItemsLoading(), ItemsNotLoaded()],
    );

    blocTest(
    'Add Item -> Loaded',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
    act: (bloc){
      bloc.add(LoadItemsFromCage([testItemLocal.id]));
      bloc.add(AddItem(testItemRemote));
      return;
      },
    expect: [ItemsLoading(), ItemsLoaded([testItemLocal]), 
    ItemsLoaded([testItemLocal, testItemRemote])],
    );

    blocTest(
    'Update Item -> Loaded',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
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
    'Delete Item -> Loaded',
    build: () => ItemBloc(itemRepository: _itmRepLocal),
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
  });
}

