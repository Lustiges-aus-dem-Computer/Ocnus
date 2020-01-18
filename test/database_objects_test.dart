import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocnus/business_logic/category.dart';
import 'package:ocnus/services/definitions.dart';

void main() {
  Logger.level = Level.debug;

  group('Categry', (){

    Category testCat = new Category(
        color: 'black',
        title: 'Some Title',
        icon: 'blender',
        location: 'Behind the cat',
      );
      
    test('Create new Category', () async {

      DateTime _now = DateTime.now();

      expect(testCat.color, 'black');
      expect(testCat.title, 'Some Title');
      expect(testCat.location, 'Behind the cat');
      expect(testCat.active, true);
      expect(testCat.icon, 'blender');
      expect(testCat.id, isNotNull);
      expect(testCat.created.isBefore(_now), true);
      expect(testCat.modified.isBefore(_now), true);

      expect(() => new Category(
        color: 'black',
        title: 'Some Title',
        location: 'Behind the cat',
        icon: 'blender',
        id: '1'*(globalKeyLength+1)),
        throwsException);
    });

    test('Change Category', () async {
      DateTime _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      testCat.title = 'New Title';
      expect(testCat.title, 'New Title');
      expect(testCat.modified.isAfter(_now), true);
    });
  });
}