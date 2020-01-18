import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:oknos/services/database_manager.dart';
import 'package:oknos/business_logic/repository.dart';
import 'package:oknos/business_logic/category.dart';

class MockManager extends Mock implements DatabaseManager {}


void main() {
  Logger.level = Level.debug;
  Category testCatLocal = new Category(
        color: 'black',
        title: 'Some Title',
        icon: 'blender',
        location: 'Local',
      );
  Category testCatRemote = new Category(
        color: 'black',
        title: 'Some Title',
        icon: 'blender',
        location: 'Remote',
      );

  group('Category Repository', () {
    var mockManagerLocal = MockManager();
    when(mockManagerLocal.putCategories([testCatLocal])).thenAnswer((_) => Future.value());
    when(mockManagerLocal.getCategories()).thenAnswer((_) => Future.value([testCatLocal]));
    var mockManagerRemote = MockManager();
    when(mockManagerRemote.putCategories([testCatRemote])).thenAnswer((_) => Future.value());
    when(mockManagerRemote.getCategories()).thenAnswer((_) => Future.value([testCatRemote]));
    test('Create Category Repository', () async {
      expect(() => CategoryRepository(), throwsException);
    });
    test('Save to Category Repository', () async {
      CategoryRepository _repository = CategoryRepository(localDatabaseManager: mockManagerLocal, remoteDatabaseManager: mockManagerRemote);

      await _repository.saveCategories([testCatLocal]);
    });
    test('Get Data from local Category Repository', () async {
      CategoryRepository _repository = CategoryRepository(localDatabaseManager: mockManagerLocal);
      await _repository.saveCategories([testCatLocal]);
      expect(await _repository.loadCategories(), [testCatLocal]);
    });
    test('Get Data from remote Category Repository', () async {
      CategoryRepository _repository = CategoryRepository(remoteDatabaseManager: mockManagerRemote);
      await _repository.saveCategories([testCatRemote]);
      expect(() async => await _repository.loadCategories(remote: false), throwsException);
      expect(await _repository.loadCategories(remote: true), [testCatRemote]);
    });
  });
}