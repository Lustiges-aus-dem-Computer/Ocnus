import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rentables/rentables.dart';

/// Mocking the database manager
class MockManager extends Mock implements DatabaseManager {}

void main() {
  Logger.level = Level.debug;
  var testCatLocal = Category(
    created: DateTime.now(),
    modified: DateTime.now(),
    id: LocalIdGenerator().getId(),
    color: 'black',
    title: 'Some Title',
    icon: 'blender',
    location: 'Local',
  );

  var testCatRemote = Category(
    created: DateTime.now(),
    modified: DateTime.now(),
    id: LocalIdGenerator().getId(),
    color: 'black',
    title: 'Some Title',
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

  var testResLocal = Reservation(
    created: DateTime.now(),
    modified: DateTime.now(),
    id: LocalIdGenerator().getId(),
    employee: 'Jürgen',
    itemId: testItemLocal.id,
    customerName: 'Local',
    customerMail: 'ernst_august@neuland.de',
    customerPhone: '+49 3094 988 78 00',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(Duration(days: 1)),
    fetchedOn: DateTime.now().add(Duration(days: 1)),
    returnedOn: DateTime.now().add(Duration(days: 2))
  );

  var testResLocalConflict = Reservation(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      employee: 'Jürgen',
      itemId: testItemLocal.id,
      customerName: 'Local',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 3)),
      fetchedOn: DateTime.now().add(Duration(days: 1)),
      returnedOn: DateTime.now().add(Duration(days: 3))
  );

  var testResRemote = Reservation(
    created: DateTime.now(),
    modified: DateTime.now(),
    id: LocalIdGenerator().getId(),
    employee: 'Jürgen',
    itemId: testItemRemote.id,
    customerName: 'Remote',
    customerMail: 'ernst_august@neuland.de',
    customerPhone: '+49 3094 988 78 00',
    startDate: DateTime.now().add(Duration(days: 10)),
    endDate: DateTime.now().add(Duration(days: 15)),
    fetchedOn: DateTime.now().add(Duration(days: 9)),
    returnedOn: DateTime.now().add(Duration(days: 18))
  );

  var testResRemoteConflict = Reservation(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      employee: 'Jürgen',
      itemId: testItemRemote.id,
      customerName: 'Remote',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.now().add(Duration(days: 1)),
      endDate: DateTime.now().add(Duration(days: 20)),
      fetchedOn: DateTime.now().add(Duration(days: 1)),
      returnedOn: DateTime.now().add(Duration(days: 22))
  );

  testItemLocal = testItemLocal.copyWith(reservations: [testResLocal.id]);
  testItemRemote = testItemRemote.copyWith(reservations: [testResRemote.id]);

  var imageBytes =  Uint8List(1234);

var mockManagerLocal = MockManager();
    when(mockManagerLocal.putItems([testItemLocal]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getItems([testItemLocal.id]))
        .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocal.getItems())
        .thenAnswer((_) => Future.value([testItemLocal]));

    when(mockManagerLocal.deleteItems([testItemLocal.id]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.putCategories([testCatLocal]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getCategories())
        .thenAnswer((_) => Future.value([testCatLocal]));

    when(mockManagerLocal.deleteCategories([testCatLocal.id]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.putReservations([testResLocal]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getReservations(testItemLocal.id))
        .thenAnswer((_) => Future.value([testResLocal]));

    when(mockManagerLocal.deleteReservations([testItemLocal.id]))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.putImages(keys: [testItemLocal.id], 
      imageBytes: [imageBytes], thumbnail: false))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.putImages(keys: [testItemLocal.id], 
      imageBytes: [imageBytes], thumbnail: true))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.getImages([testItemLocal.id], thumbnail: true))
        .thenAnswer((_) => Future.value([imageBytes]));
    
    when(mockManagerLocal.getImages([testItemLocal.id], thumbnail: false))
        .thenAnswer((_) => Future.value([imageBytes]));

    when(mockManagerLocal.deleteImages([testItemLocal.id], thumbnail: true))
        .thenAnswer((_) => Future.value());

    when(mockManagerLocal.deleteImages([testItemLocal.id], thumbnail: false))
        .thenAnswer((_) => Future.value());

    var mockManagerRemote = MockManager();
    when(mockManagerRemote.putItems([testItemRemote]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getItems([testItemRemote.id]))
        .thenAnswer((_) => Future.value([testItemRemote]));

    when(mockManagerRemote.deleteItems([testItemRemote.id]))
        .thenAnswer((_) => Future.value());
    
    when(mockManagerRemote.putCategories([testCatRemote]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getCategories())
        .thenAnswer((_) => Future.value([testCatRemote]));
    
    when(mockManagerRemote.deleteCategories([testCatRemote.id]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.putReservations([testResRemote]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getReservations(testItemRemote.id))
        .thenAnswer((_) => Future.value([testResRemote]));

    when(mockManagerRemote.deleteReservations([testItemRemote.id]))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.putImages(keys: [testItemLocal.id], 
      imageBytes: [imageBytes], thumbnail: false))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.putImages(keys: [testItemLocal.id], 
      imageBytes: [imageBytes], thumbnail: true))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.getImages([testItemLocal.id], thumbnail: true))
        .thenAnswer((_) => Future.value([imageBytes]));
    
    when(mockManagerRemote.getImages([testItemLocal.id], thumbnail: false))
        .thenAnswer((_) => Future.value([imageBytes]));

    when(mockManagerRemote.deleteImages([testItemLocal.id], thumbnail: true))
        .thenAnswer((_) => Future.value());

    when(mockManagerRemote.deleteImages([testItemLocal.id], thumbnail: false))
        .thenAnswer((_) => Future.value());

  test('Create Repository', () async {
      expect(() => Repository(), throwsException);
    });

  group('Category Repository', () {
    test('Save to Category Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveCategories([testCatLocal]);
    });
    test('Delete from Category Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveCategories([testCatLocal]);
      await _repository.deleteCategories([testCatLocal.id]);
    });
    test('Get Data from local Category Repository', () async {
      var _repository =
          Repository(localDatabaseManager: mockManagerLocal);
      await _repository.saveCategories([testCatLocal]);
      expect(await _repository.loadCategories(), [testCatLocal]);
    });
    test('Get Data from remote Category Repository', () async {
      var _repository =
          Repository(remoteDatabaseManager: mockManagerRemote);
      var _repositoryLoc =
          Repository(localDatabaseManager: mockManagerLocal);
      await _repository.saveCategories([testCatRemote]);
      expect(() async => await _repository.loadCategories(remote: false),
          throwsException);
      expect(() async => await _repositoryLoc.loadCategories(remote: true),
          throwsException);
      expect(await _repository.loadCategories(remote: true), [testCatRemote]);
    });
  });

  group('Reservation Repository', () {
    test('Check if an update would be valid', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveItems([testItemRemote]);
      await _repository.saveItems([testItemLocal]);

      expect(await _repository.checkValidUpdate(
        reservationList: [testResRemoteConflict], remote: true), false);
      expect(await _repository.checkValidUpdate(
        reservationList: [testResLocalConflict], remote: false), false);
    });
    test('Save Reservation to remote Repository', () async {
      var _repository = Repository(
          localDatabaseManager: null,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveReservations([testResRemote]);
    });
    test('Save Reservation to local Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: null);

      await _repository.saveReservations([testResLocal]);
    });
    test('Delete from Reservation Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.deleteReservations([testResLocal.id]);
    });
    test('Get Data from local Reservation Repository', () async {
      var _repository =
          Repository(localDatabaseManager: mockManagerLocal);
      await _repository.saveReservations([testResLocal]);
      await _repository.saveItems([testItemLocal]);
      expect(await _repository
      .loadReservations(testItemLocal.id), [testResLocal]);
    });
    test('Get Data from remote Reservation Repository', () async {
      var _repository =
          Repository(remoteDatabaseManager: mockManagerRemote);
      var _repositoryLoc =
          Repository(localDatabaseManager: mockManagerLocal);
      expect(() async => await _repository.loadReservations(testItemLocal.id, 
      remote: false), throwsException);
      expect(() async 
      => await _repositoryLoc.loadReservations(testItemRemote.id, 
      remote: true), throwsException);
      expect(await _repository.loadReservations(testItemRemote.id, 
      remote: true), [testResRemote]);
    });
  });

  group('Item Repository', () {
    test('Save to Item Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveItems([testItemLocal]);
    });
    test('Delete from Item Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveItems([testItemLocal]);
      await _repository.deleteItems([testItemLocal.id]);
    });
    test('Get Data from local Item Repository', () async {
      var _repository =
          Repository(localDatabaseManager: mockManagerLocal);
      await _repository.saveItems([testItemLocal, testItemRemote]);
      /// Load a specific list of items
      expect(await _repository.loadItems(
        idList: [testItemLocal.id]), [testItemLocal]);
    });
    test('Get item search terms', () async {
      var _repository =
          Repository(localDatabaseManager: mockManagerLocal);

      expect(await _repository.getSearchParameters(), {testItemLocal.id:
      {searchParameters.category: testItemLocal.categoryId,
       searchParameters.searchTerm: 
       '${testItemLocal.title} ${testItemLocal.description}'}});
    });
    test('Get Data from remote Item Repository', () async {
      var _repository =
          Repository(remoteDatabaseManager: mockManagerRemote);
      var _repositoryLoc =
          Repository(localDatabaseManager: mockManagerLocal);
      await _repository.saveItems([testItemRemote]);
      expect(() async => await _repository
      .loadItems(idList: [testItemRemote.id], remote: false), throwsException);
      expect(() async => await _repositoryLoc
      .loadItems(idList: [testItemRemote.id], remote: true), throwsException);
      expect(await _repository
      .loadItems(idList: [testItemRemote.id], remote: true), [testItemRemote]);
    });
  });

  group('Image Repository', () {
    test('Save to Item Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveImages(
        imageBytes: [imageBytes], keys: [testItemLocal.id]);
    });
    test('Delete from Image Repository', () async {
      var _repository = Repository(
          localDatabaseManager: mockManagerLocal,
          remoteDatabaseManager: mockManagerRemote);

      await _repository.saveImages(
        imageBytes: [imageBytes], keys: [testItemLocal.id]);
      await _repository.deleteImages([testItemLocal.id]);
    });
    test('Get Data from local Image Repository', () async {
      var _repository =
          Repository(localDatabaseManager: mockManagerLocal);
      await _repository.saveImages(
        imageBytes: [imageBytes], keys: [testItemLocal.id]);
      /// Load a specific list of images
      expect((await _repository.loadImages(
        [testItemLocal.id]))[0], imageBytes);
    });
    test('Get Data from remote Image Repository', () async {
      var _repository =
          Repository(remoteDatabaseManager: mockManagerRemote);
      await _repository.saveImages(
        imageBytes: [imageBytes], keys: [testItemLocal.id]);
      /// Load a specific list of images
      expect((await _repository.loadImages(
        [testItemLocal.id], remote: true))[0], imageBytes);
    });
  });
}
