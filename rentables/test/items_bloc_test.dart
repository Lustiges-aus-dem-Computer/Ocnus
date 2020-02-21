import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';
import 'package:rentables/src/blocs/items_bloc.dart';
import 'package:rentables/src/blocs/items_events.dart';
import 'package:rentables/src/services/connectivity.dart';

/// Mocking the DNS service
class MockDNS extends Mock {
  /// Mocked DNS package returned from the server
  Future<DnsPacket> lookupPacket(String _);
}

class Answer{
  String name;
  Answer(this.name);
}

class DnsPacket{
  bool isResponse;
  List<Answer> answers;

  DnsPacket(this.answers, {this.isResponse});
}

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  BlocSupervisor.delegate = RentableBlocDelegate();
  group('Items Bloc tests', (){
    Logger.level = Level.debug;

    var _validAnswers = [Answer('google.com')];
    var _invalidAnswers = [null];

    var _validPacket = DnsPacket(_validAnswers, isResponse: true);
    var _invalidPacket= DnsPacket(_invalidAnswers, isResponse: false);

    var validMockDNS = MockDNS();
    when(validMockDNS.lookupPacket('google.com'))
        .thenAnswer((_) => Future.value(_validPacket));

    var invalidMockDNS = MockDNS();
    when(invalidMockDNS.lookupPacket('google.com'))
        .thenAnswer((_) => Future.value(_invalidPacket));

    var offlineConnect = Connectivity(client: invalidMockDNS);

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

    var mockManagerLocalLoadError= MockManager();
    when(mockManagerLocalLoadError.getItems([testItemRemote.id]))
        .thenAnswer((_) => throw Exception('Error'));

    var _itemRepLocalError =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocalError);
    var _itemRepLocalLoadError =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocalLoadError);
    var _itmRepLocal = 
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocal);

    blocTest(
    'Initialize Bloc',
    build: () => ItemBloc(repository: _itmRepLocal),
    expect: [ItemsLoading()],
    );

    blocTest(
    'Loading -> Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc) => bloc.add(LoadItems([testItemLocal.id])),
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
    'Loading -> Loaded - Error',
    build: () => ItemBloc(repository: _itemRepLocalLoadError),
    act: (bloc) => bloc.add(LoadItems([testItemRemote.id])),
    expect: [ItemsLoading(), ItemsNotLoaded()],
    );

    blocTest(
    'Add Item -> Loaded',
    build: () => ItemBloc(repository: _itmRepLocal),
    act: (bloc){
      bloc.add(LoadItems([testItemLocal.id]));
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
        bloc.add(LoadItems([testItemLocal.id]));
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
      bloc.add(LoadItems([testItemLocal.id]));
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
        bloc.add(LoadItems([testItemLocal.id]));
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
      bloc.add(LoadItems([testItemLocal.id]));
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
        bloc.add(LoadItems([testItemLocal.id]));
        bloc.add(DeleteItem(testItemLocal));
        return;
      },
      expect: [ItemsLoading(), ItemsLoaded([testItemLocal]),
        ItemsUpdateFailed()],
    );
  });
}

