import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';

import '../rentables.dart';


void main() {
  Logger.level = Level.debug;

  group('Categry', () {
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
    });

    test('Change Category', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      testCat.title = 'New Title';
      testCat.icon = 'yinYang';
      testCat.color = 'white';
      testCat.location = 'New location';
      testCat.active = false;
      expect(testCat.title, 'New Title');
      expect(testCat.icon, 'yinYang');
      expect(testCat.color, 'white');
      expect(testCat.location, 'New location');
      expect(testCat.active, false);
      expect(testCat.modified.isAfter(_now), true);
    });
  });


  group('Reservation', () {
    var testRes = Reservation(
      employee: 'Jürgen',
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
      expect(testRes.id, isNotNull);
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
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 02, 04);
      testRes.fetchedOn = DateTime.utc(2020, 02, 01);
      testRes.returnedOn = DateTime.utc(2020, 05, 04);

      expect(testRes.employee, 'Gunter');
      expect(testRes.customerName, 'Ludwig Maximilian');
      expect(testRes.customerMail, 'sexy-tiger@neuland.de');
      expect(testRes.customerPhone, '');
      expect(testRes.id, isNotNull);
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

      expect(testRes.startDate, DateTime.utc(2020, 03, 01));
      expect(testRes.endDate, DateTime.utc(2020, 03, 01));
      expect(testRes.fetchedOn, DateTime.utc(2020, 02, 01));

      /// Set invalid end date
      testRes.fetchedOn = DateTime.utc(2020, 02, 01);
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 01, 01);
      
      expect(testRes.startDate, DateTime.utc(2020, 01, 01));
      expect(testRes.endDate, DateTime.utc(2020, 01, 01));
      expect(testRes.fetchedOn, DateTime.utc(2020, 01, 01));

      /// Set invalid fetched-on date
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 03, 01);
      testRes.fetchedOn = DateTime.utc(2020, 04, 01);
      
      expect(testRes.startDate, DateTime.utc(2020, 02, 01));
      expect(testRes.endDate, DateTime.utc(2020, 04, 01));
      expect(testRes.fetchedOn, DateTime.utc(2020, 04, 01));

      /// Set invalid returned-on date
      testRes.startDate = DateTime.utc(2020, 02, 01);
      testRes.endDate = DateTime.utc(2020, 04, 01);
      testRes.fetchedOn = DateTime.utc(2020, 03, 01);
      testRes.returnedOn = DateTime.utc(2020, 01, 01);
      
      expect(testRes.startDate, DateTime.utc(2020, 01, 01));
      expect(testRes.endDate, DateTime.utc(2020, 04, 01));
      expect(testRes.fetchedOn, DateTime.utc(2020, 01, 01));
      expect(testRes.returnedOn, DateTime.utc(2020, 01, 01));
    });
  });

}
