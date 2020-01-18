import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ocnus/business_logic/category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:ocnus/services/database_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.debug;
  Hive.registerAdapter(CategoryAdapter());

    var testCat = Category(
        color: 'black',
        title: 'Some Title',
        icon: 'blender',
        location: 'Behind the cat',
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

  group('Hive', (){
    test('Open and close box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.dismiss();
    });

    test('Write to box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      await _hiveManager.dismiss();
    });

    test('Read from box', () async {
      var _hiveManager = HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      var _readCats = await _hiveManager.getCategories();
      expect(_readCats[0].id, testCat.id);
      expect(_readCats[0].title, testCat.title);
      expect(_readCats[0].color, testCat.color);
      expect(_readCats[0].icon, testCat.icon);
      await _hiveManager.dismiss();
    });
  });
}