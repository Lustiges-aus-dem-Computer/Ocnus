import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentables/rentables.dart';

void main() {
  Logger.level = Level.debug;

  group('Category', () {
    var testCat = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
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

    test('Copy Category', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      var testCatCopy = testCat.copyWith(
        title: 'New Title',
        icon: 'yinYang',
        color: 'white',
        location: 'New location',
        active: false,
      );

      expect(testCatCopy.title, 'New Title');
      expect(testCatCopy.icon, 'yinYang');
      expect(testCatCopy.color, 'white');
      expect(testCatCopy.location, 'New location');
      expect(testCatCopy.active, false);
      expect(testCatCopy.modified.isAfter(_now), true);
    });
  });


  group('Reservation', () {
    var testItem = Item(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      title: 'New Item',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      images: []
    );

    var testRes = Reservation(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      employee: 'Jürgen',
      itemId: testItem.id,
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
      expect(testRes.startDate, DateTime.utc(2020, 01, 01));
      expect(testRes.endDate, DateTime.utc(2020, 01, 04));
      expect(testRes.created.isBefore(_now), true);
      expect(testRes.modified.isBefore(_now), true);
    });

    test('Copy Reservation', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      var testResCopy = testRes.copyWith(
        employee: 'Gunter',
        customerName: 'Ludwig Maximilian',
        customerMail: 'sexy-tiger@neuland.de',
        customerPhone: '',
        startDate: DateTime.utc(2020, 02, 01),
        endDate: DateTime.utc(2020, 02, 04),
        fetchedOn: DateTime.utc(2020, 02, 01),
        returnedOn: DateTime.utc(2020, 05, 04)
      );

      expect(testResCopy.id, testRes.id);

      /// Checks all other data
      expect(testResCopy.employee, 'Gunter');
      expect(testResCopy.customerName, 'Ludwig Maximilian');
      expect(testResCopy.customerMail, 'sexy-tiger@neuland.de');
      expect(testResCopy.customerPhone, '');
      expect(testResCopy.itemId, testItem.id);
      expect(testResCopy.startDate, DateTime.utc(2020, 02, 01));
      expect(testResCopy.endDate, DateTime.utc(2020, 02, 04));
      expect(testResCopy.fetchedOn, DateTime.utc(2020, 02, 01));
      expect(testResCopy.returnedOn, DateTime.utc(2020, 05, 04));
      expect(testResCopy.modified.isAfter(_now), true);
    });

    test('Error-Handling', () async {
      /// Set invalid start date
      var testResCopy = testRes.copyWith(
        endDate: DateTime.utc(2020, 02, 01),
        fetchedOn: DateTime.utc(2020, 02, 01),
        startDate: DateTime.utc(2020, 03, 01)
      );

      expect(testResCopy.startDate, DateTime.utc(2020, 03, 01));
      expect(testResCopy.endDate, DateTime.utc(2020, 03, 02));
      expect(testResCopy.fetchedOn, DateTime.utc(2020, 02, 01));

      /// Set invalid end date
      testResCopy = testRes.copyWith(
        fetchedOn: DateTime.utc(2020, 02, 01),
        startDate: DateTime.utc(2020, 02, 01),
        endDate: DateTime.utc(2020, 01, 02)
      );
      
      expect(testResCopy.startDate, DateTime.utc(2020, 02, 01));
      expect(testResCopy.endDate, DateTime.utc(2020, 02, 02));
      expect(testResCopy.fetchedOn, DateTime.utc(2020, 02, 01));

      /// Set invalid fetched-on date
      testResCopy = testRes.copyWith(
        startDate: DateTime.utc(2020, 02, 01),
        endDate: DateTime.utc(2020, 03, 01),
        fetchedOn: DateTime.utc(2020, 04, 01)
      );
      
      expect(testResCopy.startDate, DateTime.utc(2020, 02, 01));
      expect(testResCopy.endDate, DateTime.utc(2020, 04, 02));
      expect(testResCopy.fetchedOn, DateTime.utc(2020, 04, 01));

      /// Set invalid returned-on date
      testResCopy = testRes.copyWith(
        startDate: DateTime.utc(2020, 02, 01),
        endDate: DateTime.utc(2020, 04, 01),
        fetchedOn: DateTime.utc(2020, 03, 01),
        returnedOn: DateTime.utc(2020, 01, 01)
      );
      
      expect(testResCopy.startDate, DateTime.utc(2020, 02, 01));
      expect(testResCopy.endDate, DateTime.utc(2020, 04, 01));
      expect(testResCopy.fetchedOn, DateTime.utc(2019, 12, 31));
      expect(testResCopy.returnedOn, DateTime.utc(2020, 01, 01));
    });
  });



  group('Item', () {
    var testCat = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'black',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testCat2 = Category(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      color: 'white',
      title: 'Some Title',
      icon: 'blender',
      location: 'Behind the cat',
    );

    var testItem = Item(
      created: DateTime.now(),
      modified: DateTime.now(),
      id: LocalIdGenerator().getId(),
      images: ['Test-Image'],
      title: 'New Item',
      size: 'L',
      type: 'm',
      description: 'This is a test-item',
      categoryId: testCat.id
    );

    test('Create new Item', () async {
      var _now = DateTime.now();

      expect(testItem.title, 'New Item');
      expect(testItem.size, 'L');
      expect(testItem.type, 'm');
      expect(testItem.images, ['Test-Image']);
      expect(testItem.active, true);
      expect(testItem.description, 'This is a test-item');
      expect(testItem.categoryId, testCat.id);
      expect(testItem.id, isNotNull);
      expect(testItem.created.isBefore(_now), true);
      expect(testItem.modified.isBefore(_now), true);
    });

    test('Copy Item', () async {
      var _now = DateTime.now();

      await Future.delayed(Duration(milliseconds: 50));

      var testItemCopy = testItem.copyWith(
        title: 'New Title',
        size: 'M',
        type: 'f',
        images: ['New-Image'],
        description: 'Changed',
        active: false,
        reservations: ['hzu86d'],
        categoryId: testCat2.id
      );

      expect(testItemCopy.title, 'New Title');
      expect(testItemCopy.size, 'M');
      expect(testItemCopy.type, 'f');
      expect(testItemCopy.images, ['New-Image']);
      expect(testItemCopy.active, false);
      expect(testItemCopy.reservations, ['hzu86d']);
      expect(testItemCopy.description, 'Changed');
      expect(testItemCopy.categoryId, testCat2.id);
      expect(testItemCopy.modified.isAfter(_now), true);

      testItemCopy = testItem.copyWith(
          categoryId: null
      );

      expect(testItemCopy.categoryId, isNull);
    });

    test('Delete Category ID', () async {
      var testItemCopy = testItem.deleteCategory();
      expect(testItemCopy.categoryId, null);
    });
  });

}