import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../business_logic/category.dart';
import '../services/local_id_generator.dart';

/// Abstract class for all database interfaces (managers)
abstract class DatabaseManager {
  /// Function to initialize the manager
  Future<void> initialize();

  /// Function to dismiss the manager
  Future<void> dismiss();

  /// Function to request loading categories from the database
  Future<List<Category>> getCategories();

  /// Function to request saving categories to the database
  Future<void> putCategories(List<Category> _categoryList);
}

/// Database interface (manager) for the Hive database
/// https://docs.hivedb.dev/#/
class HiveManager implements DatabaseManager {
  /// Hive box for saving categories -> non-lazy because there
  /// is little data and all of it can be kept in memory
  Box<Category> categoryCageBox;
  LocalIdGenerator _idGenerator;

  /// Initialize the hive box
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    _idGenerator = LocalIdGenerator();
    categoryCageBox = await Hive.openBox<Category>('categoryCageBox');
  }

  @override
  Future<void> dismiss() async {
    categoryCageBox.close();
  }

  @override
  Future<List<Category>> getCategories() async {
    var _categoryList = <Category>[];
    for (int _id in categoryCageBox.keys.toList()) {
      _idGenerator.keyIndex = _id;
      _categoryList.add(categoryCageBox.get(_id));
    }
    return _categoryList;
  }

  @override
  Future<void> putCategories(List<Category> _categoryList) async {
    for (var _category in _categoryList) {
      categoryCageBox.put(_category.hiveId, _category);
    }
    return;
  }
}
