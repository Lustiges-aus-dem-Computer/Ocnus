import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';

import '../rentables.dart';


void main() {
  Logger.level = Level.debug;

  group('Category', () {
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
      expect(testCat.hiveId, isNotNull);
      expect(testCat.created.isBefore(_now), true);
      expect(testCat.modified.isBefore(_now), true);
    });

    test('Change Category', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      testCat.title = 'New Title';
      testCat.icon = 'yinYang';
      testCat.color = 'white';
      testCat.location = 'New location';
      testCat.active = false;
      testCat.update();
      expect(testCat.title, 'New Title');
      expect(testCat.icon, 'yinYang');
      expect(testCat.color, 'white');
      expect(testCat.location, 'New location');
      expect(testCat.active, false);
      expect(testCat.modified.isAfter(_now), true);
    });
  });


  group('Reservation', () {
    var testItem = Item(
      title: 'New Item',
      size: 'L',
      type: 'm',
      description: 'This is a test-item'
    );

    var testItem2 = Item(
      title: 'All-New Item',
      size: 'L',
      type: 'm',
      description: 'This is a test-item'
    );


    var testRes = Reservation(
      employee: 'Jürgen',
      item: testItem,
      customerName: 'Ernst August',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.utc(2020, 01, 01),
      endDate: DateTime.utc(2020, 01, 04)
    );

    test('Create new Reservation', () async {
      var _now = DateTime.now();

      expect(testRes.employee, 'Jürgen');
      expect(testRes.customerName, 'Ernst August');
      expect(testRes.customerMail, 'ernst_august@neuland.de');
      expect(testRes.customerPhone, '+49 3094 988 78 00');
      expect(testRes.itemId, testItem.id);
      expect(testRes.id, isNotNull);
      expect(testRes.hiveId, isNotNull);
      expect(testRes.startDate, DateTime.utc(2020, 01, 01));
      expect(testRes.endDate, DateTime.utc(2020, 01, 04));
      expect(testRes.created.isBefore(_now), true);
      expect(testRes.modified.isBefore(_now), true);
    });

    test('Change Reservation', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      testRes.employee = 'Gunter';
      testRes.customerName = 'Ludwig Maximilian';
      testRes.customerMail = 'sexy-tiger@neuland.de';
      testRes.customerPhone = '';
      testRes.item = testItem2;
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 02, 04);
      testRes.fetchedOn = DateTime.utc(2020, 02, 01);
      testRes.returnedOn = DateTime.utc(2020, 05, 04);

      testRes.update();
      expect(testRes.employee, 'Gunter');
      expect(testRes.customerName, 'Ludwig Maximilian');
      expect(testRes.customerMail, 'sexy-tiger@neuland.de');
      expect(testRes.customerPhone, '');
      expect(testRes.id, isNotNull);
      expect(testRes.itemId, testItem2.id);
      expect(testRes.item, testItem2);
      expect(testRes.startDate, DateTime.utc(2020, 02, 01));
      expect(testRes.endDate, DateTime.utc(2020, 02, 04));
      expect(testRes.fetchedOn, DateTime.utc(2020, 02, 01));
      expect(testRes.returnedOn, DateTime.utc(2020, 05, 04));
      expect(testRes.modified.isAfter(_now), true);
    });

    test('Error-Handling', () async {
      /// Set invalid start date
      testRes.endDate = DateTime.utc(2020, 02, 01);
      testRes.fetchedOn = DateTime.utc(2020, 02, 01);
      testRes.startDate = DateTime.utc(2020, 03, 01);

      testRes.update();
      expect(testRes.startDate, DateTime.utc(2020, 03, 01));
      expect(testRes.endDate, DateTime.utc(2020, 03, 02));
      expect(testRes.fetchedOn, DateTime.utc(2020, 02, 01));

      /// Set invalid end date
      testRes.fetchedOn = DateTime.utc(2020, 02, 01);
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 01, 02);
      
      testRes.update();
      expect(testRes.startDate, DateTime.utc(2020, 02, 01));
      expect(testRes.endDate, DateTime.utc(2020, 02, 02));
      expect(testRes.fetchedOn, DateTime.utc(2020, 02, 01));

      /// Set invalid fetched-on date
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 03, 01);
      testRes.fetchedOn = DateTime.utc(2020, 04, 01);
      
      testRes.update();
      expect(testRes.startDate, DateTime.utc(2020, 02, 01));
      expect(testRes.endDate, DateTime.utc(2020, 04, 02));
      expect(testRes.fetchedOn, DateTime.utc(2020, 04, 01));

      /// Set invalid returned-on date
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 04, 01);
      testRes.fetchedOn = DateTime.utc(2020, 03, 01);
      testRes.returnedOn = DateTime.utc(2020, 01, 01);
      
      testRes.update();
      expect(testRes.startDate, DateTime.utc(2020, 02, 01));
      expect(testRes.endDate, DateTime.utc(2020, 04, 01));
      expect(testRes.fetchedOn, DateTime.utc(2019, 12, 31));
      expect(testRes.returnedOn, DateTime.utc(2020, 01, 01));
    });
  });



  group('Item', () {
    var testCat = Category(
      color: 'black',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testCat2 = Category(
      color: 'white',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testItem = Item(
      title: 'New Item',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      category: testCat
    );

    test('Create new Item', () async {
      var _now = DateTime.now();

      expect(testItem.title, 'New Item');
      expect(testItem.size, 'L');
      expect(testItem.type, 'm');
      expect(testItem.active, true);
      expect(testItem.description, 'This is a test-item');
      expect(testItem.category.id, testCat.id);
      expect(testItem.id, isNotNull);
      expect(testItem.hiveId, isNotNull);
      expect(testItem.created.isBefore(_now), true);
      expect(testItem.modified.isBefore(_now), true);
    });

    test('Change Item', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      testItem.title = 'New Title';
      testItem.size = 'M';
      testItem.type = 'f';
      testItem.description = 'Changed';
      testItem.active = false;
      testItem.category = testCat2;

      testItem.update();
      expect(testItem.title, 'New Title');
      expect(testItem.size, 'M');
      expect(testItem.type, 'f');
      expect(testItem.active, false);
      expect(testItem.description, 'Changed');
      expect(testItem.category.id, testCat2.id);
      expect(testItem.modified.isAfter(_now), true);
    });

    test('Raise Errors in Items', () async {
      expect(() => 
        Item(
          title: 'New Item',
          size: 'L',
          type: 'mf',
          description: 'This is a test-item',
          category: testCat
        ), throwsException);
      
      expect(() => 
        Item(
          title: 'New Item',
          size: 'L',
          type: 'k',
          description: 'This is a test-item',
          category: testCat
        ), throwsException);
    });
  });

}
