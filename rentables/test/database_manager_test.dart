import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'package:rentables/rentables.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.debug;
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ReservationAdapter());
  Hive.registerAdapter(ItemAdapter());

  var testCat = Category(
    color: 'black',
    title: 'Some Title',
    icon: 'blender',
    location: 'Behind the cat',
  );

  var testItem = Item(
      title: 'New Item',
      size: 'L',
      type: 'm',
      description: 'This is a test item',
      category: testCat
    );

  var testItem2 = Item(
      title: 'Second',
      size: 'L',
      type: 'm',
      description: 'This is a test item',
      category: testCat
    );

  var testRes = Reservation(
      employee: 'Jürgen',
      item: testItem,
      customerName: 'Ernst August',
      customerMail: 'ernst_august@neuland.de',
      customerPhone: '+49 3094 988 78 00',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 3)),
      fetchedOn: DateTime.now().add(Duration(days: 2)),
      returnedOn: DateTime.now().add(Duration(days: 5))
    );

  setUpAll(() async {
    // Create a temporary directory.
    final directory = await Directory.systemTemp.createTemp();

    // Mock out the MethodChannel for the path_provider plugin.
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((var methodCall) async {
      // If you're getting the apps documents directory, return the path to the
      // temp directory on the test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  });

  group('Hive', () {
    test('Open and close box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();

      await _hiveManager.clear();
    });

    test('Write Categories to box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);

      await _hiveManager.clear();
    });

    test('Write Items to box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putItems([testItem]);

      await _hiveManager.clear();
    });

    test('Write Reservations to box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putReservations([testRes]);

      await _hiveManager.clear();
    });

    test('Read Categories from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);

      List<dynamic> _readCats = await _hiveManager.getCategories();
      expect(_readCats[0].id, testCat.id);
      expect(_readCats[0].title, testCat.title);
      expect(_readCats[0].color, testCat.color);
      expect(_readCats[0].icon, testCat.icon);
      expect(_readCats[0].active, testCat.active);

      await _hiveManager.clear();
    });

    test('Read Reservations from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putReservations([testRes]);

      List<dynamic> _readRes = await _hiveManager.getReservations(testRes.item);

      expect(_readRes[0].id, testRes.id);
      expect(_readRes[0].item, testRes.item);
      expect(_readRes[0].customerMail, testRes.customerMail);
      expect(_readRes[0].customerName, testRes.customerName);
      expect(_readRes[0].employee, testRes.employee);
      /// If the comparison is too strict, we run into issues with the
      /// maximum time-resolution when saving to the database
      expect(_readRes[0].startDate.day, testRes.startDate.day);
      expect(_readRes[0].endDate.day, testRes.endDate.day);
      expect(_readRes[0].fetchedOn.day, testRes.fetchedOn.day);
      expect(_readRes[0].returnedOn.day, testRes.returnedOn.day);

      /// Test nested properties
      expect(_readRes[0].item.category.id, testRes.item.category.id);
      expect(_readRes[0].item.category.location, 
      testRes.item.category.location);
      expect(_readRes[0].item.category.modified, 
      testRes.item.category.modified);
      expect(_readRes[0].item.category.created, 
      testRes.item.category.created);

      await _hiveManager.clear();
    });

    test('Read Items from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putItems([testItem]);
      
      var _readItems = await _hiveManager.getItems();

      expect(_readItems[0].id, testItem.id);
      expect(_readItems[0].active, testItem.active);
      expect(_readItems[0].category.id, testItem.category.id);
      expect(_readItems[0].description, testItem.description);
      expect(_readItems[0].size, testItem.size);
      expect(_readItems[0].title, testItem.title);
      expect(_readItems[0].created.day, testItem.created.day);
      expect(_readItems[0].modified.day, testItem.modified.day);
      expect(_readItems[0].type, testItem.type);

      await _hiveManager.putItems([testItem2]);
      _readItems = await _hiveManager.getItems();
      expect(_readItems.length, 2);

      await _hiveManager.clear();
    });

    test('Delete Categories from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      await _hiveManager.deleteCategories([testCat.id]);
      expect((await _hiveManager.getCategories()).length, 0);

      await _hiveManager.clear();
    });

    test('Delete Reservations from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putReservations([testRes]);
      await _hiveManager.deleteReservations([testRes.id]);
      expect((await _hiveManager.getReservations(testRes.item)).length, 0);

      await _hiveManager.clear();
    });

    test('Delete Items from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putItems([testItem]);
      await _hiveManager.deleteItems([testItem.id]);
      expect((await _hiveManager.getItems()).length, 0);

      await _hiveManager.clear();
    });

    /// This is the only in-memory box so we test reading it from disk
    test('Read Categories from disk', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);

      await _hiveManager.dismiss();
      await _hiveManager.initialize();

      List<dynamic> _readCats = await _hiveManager.getCategories();
      expect(_readCats[0].id, testCat.id);
      expect(_readCats[0].title, testCat.title);
      expect(_readCats[0].color, testCat.color);
      expect(_readCats[0].icon, testCat.icon);
      expect(_readCats[0].active, testCat.active);

      await _hiveManager.clear();
    });
  });
}
