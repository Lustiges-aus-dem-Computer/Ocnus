import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:oknos/services/database_manager.dart';
import 'package:oknos/business_logic/repository.dart';

class MockManager extends Mock implements DatabaseManager {}


void main() {
  Logger.level = Level.debug;
  test('Category Repository', () async {
    expect(() => CategoryRepository(), throwsException);
  });
}