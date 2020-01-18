import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oknos/business_logic/category.dart';
import 'package:flutter/material.dart';

void main() {
  Logger.level = Level.debug;

  group('Categry', (){
    test('Create new Category', () async {
      Category _testCat = new Category(
        color: Colors.amber,
        title: 'Some Name',
        location: 'Behind the cat'
      );

      DateTime _now = DateTime.now();

      expect(_testCat.color, Colors.amber);
      expect(_testCat.title, 'Some Title');
      expect(_testCat.location, 'Behind the cat');
      expect(_testCat.active, true);
      expect(_testCat.id, isNotNull);
      expect(_testCat.created.isBefore(_now), true);
      expect(_testCat.modified.isBefore(_now), true);

      _testCat.title = 'New Title';
      expect(_testCat.title, 'New Title');
      expect(_testCat.modified.isAfter(_now), true);

    });
  });
}