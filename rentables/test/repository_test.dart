import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:rentables/rentables.dart';

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  Logger.level = Level.debug;
  var testCatLocal = Category(
    color: 'black',
    title: 'Some Title',
    icon: 'blender',
    location: 'Local',
  );
  var testCatRemote = Category(
    color: 'black',
    title: 'Some Title',
    icon: 'blender',
    location: 'Remote',
  );

  var testItemLocal = Item(
      title: 'Local',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      category: testCatLocal
    );

  var testItemRemote = Item(
      title: 'Remote',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      category: testCatRemote
    );

  var testResLocal = Reservation(
      employee: 'Jürgen',
      item: testItemLocal,
      customerName: 'Local',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 3)),
      fetchedOn: DateTime.now().add(Duration(days: 2)),
      returnedOn: DateTime.now().add(Duration(days: 5))
  );

  var testResRemote = Reservation(
      employee: 'Jürgen',
      item: testItemRemote,
      customerName: 'Remote',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 3)),
      fetchedOn: DateTime.now().add(Duration(days: 2)),
      returnedOn: DateTime.now().add(Duration(days: 5))
    );

  group('Category Repository', () {
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

    test('Create Category Repository', () async {
      expect(() => CategoryRepository(), throwsException);
    });
    test('Save to Category Repository', () async {
      var _repository = CategoryRepository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveCategories([testCatLocal]);
    });
    test('Get Data from local Category Repository', () async {
      var _repository =
          CategoryRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveCategories([testCatLocal]);
      expect(await _repository.loadCategories(), [testCatLocal]);
    });
    test('Get Data from remote Category Repository', () async {
      var _repository =
          CategoryRepository(remoteDatabaseManager: mockManagerRemote);
      var _repositoryLoc =
          CategoryRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveCategories([testCatRemote]);
      expect(() async => await _repository.loadCategories(remote: false),
          throwsException);
      expect(() async => await _repositoryLoc.loadCategories(remote: true),
          throwsException);
      expect(await _repository.loadCategories(remote: true), [testCatRemote]);
    });
  });

  group('Reservation Repository', () {
    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putReservations([testResLocal]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getReservations(testItemLocal))
        .thenAnswer((_) => Future.value([testResLocal]));

    var mockManagerRemote = MockManager();
    when(mockManagerRemote.putReservations([testResRemote]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getReservations(testItemRemote))
        .thenAnswer((_) => Future.value([testResRemote]));

    test('Create Reservation Repository', () async {
      expect(() => ReservationRepository(), throwsException);
    });
    test('Save to Reservation Repository', () async {
      var _repository = ReservationRepository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveReservations([testResLocal]);
    });
    test('Get Data from local Reservation Repository', () async {
      var _repository =
          ReservationRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveReservations([testResLocal]);
      expect(await _repository.loadReservations(testItemLocal), [testResLocal]);
    });
    test('Get Data from remote Reservation Repository', () async {
      var _repository =
          ReservationRepository(remoteDatabaseManager: mockManagerRemote);
      var _repositoryLoc =
          ReservationRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveReservations([testResRemote]);
      expect(() async => await _repository.loadReservations(testItemLocal, 
      remote: false), throwsException);
      expect(() async => await _repositoryLoc.loadReservations(testItemRemote, 
      remote: true), throwsException);
      expect(await _repository.loadReservations(testItemRemote, 
      remote: true), [testResRemote]);
    });
  });


  group('Item Repository', () {
    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putItems([testItemLocal]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getItems([testItemLocal.id]))
        .thenAnswer((_) => Future.value([testItemLocal]));

    var mockManagerRemote = MockManager();
    when(mockManagerRemote.putItems([testItemRemote]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getItems([testItemRemote.id]))
        .thenAnswer((_) => Future.value([testItemRemote]));

    test('Create Item Repository', () async {
      expect(() => ReservationRepository(), throwsException);
    });
    test('Save to Item Repository', () async {
      var _repository = ItemRepository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveItems([testItemLocal]);
    });
    test('Get Data from local Item Repository', () async {
      var _repository =
          ItemRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveItems([testItemLocal]);
      expect(await _repository.loadItems([testItemLocal.id]), [testItemLocal]);
    });
    test('Get item search terms', () async {
      var _repository =
          ItemRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveItems([testItemLocal]);
      var _title = testItemLocal.title;
      var _description = testItemLocal.description;
      expect(await _repository.getSearchterms([testItemLocal.id]),
       ['$_title $_description']);
    });
    test('Get Data from remote Item Repository', () async {
      var _repository =
          ItemRepository(remoteDatabaseManager: mockManagerRemote);
      var _repositoryLoc =
          ItemRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveItems([testItemRemote]);
      expect(() async => await _repository
      .loadItems([testItemRemote.id], remote: false), throwsException);
      expect(() async => await _repositoryLoc
      .loadItems([testItemRemote.id], remote: true), throwsException);
      expect(await _repository
      .loadItems([testItemRemote.id], remote: true), [testItemRemote]);
    });
  });
}
