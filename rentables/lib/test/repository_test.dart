import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../rentables.dart';


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

  var testResLocal = Reservation(
      employee: 'Jürgen',
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
      await _repository.saveCategories([testCatRemote]);
      expect(() async => await _repository.loadCategories(remote: false),
          throwsException);
      expect(await _repository.loadCategories(remote: true), [testCatRemote]);
    });
  });

  group('Reservation Repository', () {
    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putReservations([testResLocal]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getReservations())
        .thenAnswer((_) => Future.value([testResLocal]));

    var mockManagerRemote = MockManager();
    when(mockManagerRemote.putReservations([testResRemote]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getReservations())
        .thenAnswer((_) => Future.value([testResRemote]));

    test('Create Category Repository', () async {
      expect(() => ReservationRepository(), throwsException);
    });
    test('Save to Category Repository', () async {
      var _repository = ReservationRepository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveReservations([testResLocal]);
    });
    test('Get Data from local Category Repository', () async {
      var _repository =
          ReservationRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveReservations([testResLocal]);
      expect(await _repository.loadReservations(), [testResLocal]);
    });
    test('Get Data from remote Category Repository', () async {
      var _repository =
          ReservationRepository(remoteDatabaseManager: mockManagerRemote);
      await _repository.saveReservations([testResRemote]);
      expect(() async => await _repository.loadReservations(remote: false),
          throwsException);
      expect(await _repository.loadReservations(remote: true), [testResRemote]);
    });
  });
}
