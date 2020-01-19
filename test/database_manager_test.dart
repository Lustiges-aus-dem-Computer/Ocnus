import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ocnus/business_logic/category.dart';
import 'package:ocnus/business_logic/reservation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:ocnus/services/database_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.debug;
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(ReservationAdapter());

  var testCat = Category(
    color: 'black',
    title: 'Some Title',
    icon: 'blender',
    location: 'Behind the cat',
  );

  var testRes = Reservation(
      employee: 'Jürgen',
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
      await _hiveManager.dismiss();
    });

    test('Write Categories to box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      await _hiveManager.dismiss();
    });

    test('Write Reservations to box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putReservations([testRes]);
      await _hiveManager.dismiss();
    });

    test('Read Categories from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      await _hiveManager.putReservations([testRes]);

      List<dynamic> _readCats = await _hiveManager.getCategories();

      expect(_readCats[0].id, testCat.id);
      expect(_readCats[0].title, testCat.title);
      expect(_readCats[0].color, testCat.color);
      expect(_readCats[0].icon, testCat.icon);
      expect(_readCats[0].active, testCat.active);
      await _hiveManager.dismiss();
    });

    test('Read Reservations from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putReservations([testRes]);

      List<dynamic> _readRes = await _hiveManager.getReservations();

      expect(_readRes[0].id, testRes.id);
      expect(_readRes[0].customerMail, testRes.customerMail);
      expect(_readRes[0].customerName, testRes.customerName);
      expect(_readRes[0].employee, testRes.employee);
      /// If the comparison is too strict, we run into issues with the
      /// maximum time-resolution when saving to the database
      expect(_readRes[0].startDate.day, testRes.startDate.day);
      expect(_readRes[0].endDate.day, testRes.endDate.day);
      expect(_readRes[0].fetchedOn.day, testRes.fetchedOn.day);
      expect(_readRes[0].returnedOn.day, testRes.returnedOn.day);
      await _hiveManager.dismiss();
    });
  });
}
