import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocnus/business_logic/category.dart';
import 'package:ocnus/services/definitions.dart';

void main() {
  Logger.level = Level.debug;

  group('Categry', (){

    var testCat = Category(
        color: 'black',
        title: 'Some Title',
        icon: 'blender',
        location: 'Behind the cat',
      );
      
    test('Create new Category', () async {

      var _now = DateTime.now();

      expect(testCat.color, 'black');
      expect(testCat.title, 'Some Title');
      expect(testCat.location, 'Behind the cat');
      expect(testCat.active, true);
      expect(testCat.icon, 'blender');
      expect(testCat.id, isNotNull);
      expect(testCat.created.isBefore(_now), true);
      expect(testCat.modified.isBefore(_now), true);

      expect(() => Category(
        color: 'black',
        title: 'Some Title',
        location: 'Behind the cat',
        icon: 'blender',
        id: '1'*(humanKeyLength+1)),
        throwsException);
    });

    test('Change Category', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      testCat.title = 'New Title';
      testCat.icon = 'yinYang';
      testCat.color = 'white';
      testCat.active = false;
      expect(testCat.title, 'New Title');
      expect(testCat.icon, 'yinYang');
      expect(testCat.color, 'white');
      expect(testCat.active, false);
      expect(testCat.modified.isAfter(_now), true);
    });
  });
}