import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';
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
  group('Category Bloc tests', (){
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

    var mockManagerLocalErrorLoad = MockManager();
    when(mockManagerLocalErrorLoad.getCategories())
        .thenAnswer((_) => throw Exception('Error'));


    var mockManagerRemote = MockManager();
      when(mockManagerRemote.putCategories([testCatRemote]))
      .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getCategories())
    .thenAnswer((_) => Future.value([testCatRemote]));

    var _catRepLocalError =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocalError);
    var _catRepLocalErrorLoad =
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocalErrorLoad);
    var _catRepLocal = 
    Repository(
        connectivity: offlineConnect,
        localDatabaseManager: mockManagerLocal);

    blocTest(
    'Initialize Bloc',
    build: () => CategoryBlock(repository: _catRepLocal),
    expect: [CategoriesLoading()],
    );

    blocTest(
    'Loading -> Loaded',
    build: () => CategoryBlock(repository: _catRepLocal),
    act: (bloc) => bloc.add(LoadCategories()),
    expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal])],
    );

    blocTest(
    'Loading -> Error',
    build: () => CategoryBlock(repository: _catRepLocalErrorLoad),
    act: (bloc) => bloc.add(LoadCategories()),
    expect: [CategoriesLoading(), CategoriesNotLoaded()],
    );

    blocTest(
    'Add Category -> Loaded',
    build: () => CategoryBlock(repository: _catRepLocal),
    act: (bloc){
      bloc.add(LoadCategories());
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
        bloc.add(LoadCategories());
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
      bloc.add(LoadCategories());
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
    bloc.add(LoadCategories());
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
      bloc.add(LoadCategories());
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
        bloc.add(LoadCategories());
        bloc.add(DeleteCategory(testCatLocal));
        return;
      },
      expect: [CategoriesLoading(), CategoriesLoaded([testCatLocal]),
        CategoriesUpdateFailed()],
    );
  });
}

