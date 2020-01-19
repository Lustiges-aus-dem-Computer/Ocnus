import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../rentables.dart';

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

  /// Function to request loading reservations for 
  /// a given item from the database
  Future<List<Reservation>> getReservations(Item _item);

  /// Function to request saving reservations to the database
  Future<void> putReservations(List<Reservation> _reservationList);

  /// Function to request loading a list of IDs for all stored items
  Future<List<String>> getItemIds();

  /// Function to request loading items from the database
  /// provided a list of IDs
  Future<List<Item>> getItems(List<String> _idList);

  /// Function to request saving items to the database
  Future<void> putItems(List<Item> _itemList);
}

/// Database interface (manager) for the Hive database
/// https://docs.hivedb.dev/#/
class HiveManager implements DatabaseManager {
  final _log = getLogger();

  /// Hive box for saving categories -> non-lazy because there
  /// is little data and all of it can be kept in memory
  Box<Category> categoryCageBox;
  /// Hive box for saving reservations -> non-lazy because there
  /// is little data and all of it can be kept in memory
  Box<Reservation> reservationCageBox;
  /// Hive box for saving itams -> non-lazy because there
  /// is little data and all of it can be kept in memory
  Box<Item> itemCageBox;

  /// Initialize the hive box
  @override
  Future<void> initialize() async {
    _log.d('Initializing Hive database manager');
    await Hive.initFlutter();
    _log.d('Opening category box');
    categoryCageBox = await Hive.openBox<Category>('categoryCageBox');
    _log.d('Opening item box');
    itemCageBox = await Hive.openBox<Item>('itemCageBox');
    _log.d('Opening reservations box');
    reservationCageBox = await Hive.openBox<Reservation>('reservationCageBox');
  }

  @override
  Future<void> dismiss() async {
    _log.d('Dismissing Hive database manager');
    categoryCageBox.close();
  }

  @override
  Future<List<Category>> getCategories() async {
    _log.d('Loading categories to Hive');
    var _categoryList = <Category>[];
    for (int _id in categoryCageBox.keys.toList()) {
      _categoryList.add(categoryCageBox.get(_id));
    }
    return _categoryList;
  }

  @override
  Future<void> putCategories(List<Category> _categoryList) async {
    _log.d('Wrinting categories to Hive');
    for (var _category in _categoryList) {
      categoryCageBox.put(_category.hiveId, _category);
    }
    return;
  }

  @override
  Future<List<Reservation>> getReservations(Item _item) async {
    var _id = _item.id;
    _log.d('Loading reservations for item $_id from Hive');
    var _reservationList = <Reservation>[];
    print(_id);
    print(reservationCageBox.values.where((_reservation) 
    => _reservation.itemId == _id).toList());
    for (var _reservation in reservationCageBox.values.where((_reservation) 
    => _reservation.itemId == _id)) {
      _reservation.item = _item;
      _reservationList.add(_reservation);
    }
    return _reservationList;
  }

  @override
  Future<void> putReservations(List<Reservation> _reservationList) async {
    _log.d('Writing reservations to Hive');
    for (var _reservation in _reservationList) {
      reservationCageBox.put(_reservation.hiveId, _reservation);
    }
    return;
  }

  @override
  Future<List<String>> getItemIds() async {
    _log.d('Loading Item IDs from Hive');
    var _idList = <String>[];
    for(var _key in itemCageBox.keys){
      _idList.add(LocalIdGenerator(keyIndex: _key).getId());
    }
    return _idList;
  }

  @override
  Future<List<Item>> getItems(List<String> _idList) async {
    _log.d('Loading Items $_idList from Hive');
    var _itemList = <Item>[];
    var _item;
    for (var _id in _idList) {
      _item = itemCageBox.get(LocalIdGenerator().getHiveIdFromString(_id));
      if(_item.categoryId != null){_item.category = 
      categoryCageBox.get(LocalIdGenerator()
      .getHiveIdFromString(_item.categoryId));}
      _itemList.add(_item);
    }
    return _itemList;
  }

  @override
  Future<void> putItems(List<Item> _itemList) async {
    _log.d('Writing items to Hive');
    for (var _item in _itemList) {
      itemCageBox.put(_item.hiveId, _item);
    }
    return;
  }
}