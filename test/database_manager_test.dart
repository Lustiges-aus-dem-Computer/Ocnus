import 'dart:io';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:oknos/business_logic/category.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:oknos/services/database_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  Logger.level = Level.debug;
  Hive.registerAdapter(CategoryAdapter());

    Category testCat = new Category(
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
      .setMockMethodCallHandler((MethodCall methodCall) async {
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
      HiveManager _hiveManager = new HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.dismiss();
    });

    test('Write to box', () async {
      HiveManager _hiveManager = new HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      await _hiveManager.dismiss();
    });

    test('Read from box', () async {
      HiveManager _hiveManager = new HiveManager();
      await _hiveManager.initialize();
      await _hiveManager.putCategories([testCat]);
      List<Category> _readCats = await _hiveManager.getCategories();
      expect(_readCats[0].id, testCat.id);
      expect(_readCats[0].title, testCat.title);
      expect(_readCats[0].color, testCat.color);
      expect(_readCats[0].icon, testCat.icon);
      await _hiveManager.dismiss();
    });
  });
}