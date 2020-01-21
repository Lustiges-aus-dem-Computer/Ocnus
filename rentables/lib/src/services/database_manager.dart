import 'package:flutter/material.dart';
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

  /// Function to request deleting categories from the database
  Future<void> deleteCategories(List<String> idList);

  /// Function to request saving categories to the database
  Future<void> putCategories(List<Category> _categoryList);

  /// Function to request loading reservations for 
  /// a given item from the database
  Future<List<Reservation>> getReservations(Item _item);

  /// Function to request deleting reservations from the database
  Future<void> deleteReservations(List<String> idList);

  /// Function to request saving reservations to the database
  Future<void> putReservations(List<Reservation> _reservationList);

  /// Function to request loading items from the database
  /// provided a list of IDs
  Future<List<Item>> getItems({List<String> idList});

  /// Function to request deleting items from the database
  Future<void> deleteItems(List<String> idList);

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
  /// Hive box for saving reservations -> lazy because there
  /// might be a significant amount of data stored
  LazyBox<Reservation> reservationCageBox;
  /// Hive box for saving itams -> lazy because there
  /// might be a significant amount of data stored
  LazyBox<Item> itemCageBox;

  /// Initialize the hive box
  @override
  Future<void> initialize() async {
    _log.d('Initializing Hive database manager');
    await Hive.initFlutter();
    _log.d('Opening category box');
    categoryCageBox = await Hive.openBox<Category>('categoryCageBox');
    _log.d('Opening item box');
    itemCageBox = await Hive.openLazyBox<Item>('itemCageBox');
    _log.d('Opening reservations box');
    reservationCageBox = 
    await Hive.openLazyBox<Reservation>('reservationCageBox');
  }

  @override
  Future<void> dismiss() async {
    _log.d('Dismissing Hive database manager');
    categoryCageBox.close();
    itemCageBox.close();
    reservationCageBox.close();
  }

  /// Needed for testing to clean-up the boxes
  @visibleForTesting
  Future<void> clear() async {
    _log.d('Clear Hive database manager');
    categoryCageBox.clear();
    itemCageBox.clear();
    reservationCageBox.clear();
  }

  @override
  Future<List<Category>> getCategories() async {
    _log.d('Loading categories from Hive');
    return List<Category>.from(
      categoryCageBox.keys.map((_id) => categoryCageBox.get(_id)
    ));
  }

  @override
  Future<void> deleteCategories(List<String> idList) async {
    _log.d('Delete categories from Hive');
    for(var _id in idList){categoryCageBox.delete(
      LocalIdGenerator().getHiveIdFromString(_id));
    }
    return;
  }

  @override
  Future<void> putCategories(List<Category> _categoryList) async {
    _log.d('Wrinting categories to Hive');
    for(var _category in _categoryList){
      categoryCageBox.put(_category.hiveId, _category);
    }
    return;
  }

  @override
  Future<List<Reservation>> getReservations(Item _item) async {
    _log.d('Loading reservations for item ${_item.id} from Hive');
    return Future.wait(
      List.from(
        reservationCageBox.keys.where((_key) => 
        _item.reservationsHive.contains(_key)).map(
          (_key) async {
            var _reservation = await reservationCageBox.get(_key);
            _reservation.item = _item;
            return _reservation;
          }
        )
      )
    );
  }

  @override
  Future<void> putReservations(List<Reservation> _reservationList) async {
    _log.d('Writing reservations to Hive');
    for(var _reservation in _reservationList){
      await reservationCageBox.put(_reservation.hiveId, _reservation);
    }
    return;
  }

  @override
  Future<void> deleteReservations(List<String> idList) async {
    _log.d('Delete categories from Hive');
    for(var _id in idList){await reservationCageBox.delete(
      LocalIdGenerator().getHiveIdFromString(_id));
    }
    return;
  }

  @override
  Future<List<Item>> getItems({List<String> idList}) async {
    _log.d('Loading Items $idList from Hive');
    var _itemList = <Item>[];
    for (var _id in idList ?? itemCageBox.keys) {
      var _item = await itemCageBox.get(
        /// idList contatins the string keys so they need to be transformed
        /// into the corresponding Hive keys before the call
        idList == null ? _id : LocalIdGenerator().getHiveIdFromString(_id));
        if(_item.categoryId != null)
        {
          _item.category = categoryCageBox.get(LocalIdGenerator()
          .getHiveIdFromString(_item.categoryId));
        }
        _itemList.add(_item);
    }
    return _itemList;
  }

  @override
  Future<void> putItems(List<Item> _itemList) async {
    _log.d('Writing items to Hive');
    for(var _item in _itemList){
      if(_item.categoryId != null){
        categoryCageBox.put(LocalIdGenerator()
          .getHiveIdFromString(_item.categoryId), _item.category);
      }
      await itemCageBox.put(_item.hiveId, _item);
    }
    return;
  }

  @override
  Future<void> deleteItems(List<String> idList) async {
    _log.d('Delete Items from Hive');
    for(var _id in idList){await itemCageBox.delete(
      LocalIdGenerator().getHiveIdFromString(_id));
    }
    return;
  }
}