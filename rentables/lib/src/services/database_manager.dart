import 'dart:typed_data';
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

  /// API-wrapper to request loading categories from the database
  /// If no categories are found, an empty list should be returned
  Future<List<Category>> getCategories();

  /// API-wrapper to request deleting categories from the database
  /// Databases should handle removing all references to the deleted
  /// category in linked items before commiting the category deletion
  Future<void> deleteCategories(List<String> idList);

  /// API-wrapper to request saving categories to the database
  Future<void> putCategories(List<Category> _categoryList);

  /// API-wrapper to request loading reservations for 
  /// a given item from the database
  /// If no reservations are found, an empty list should be returned
  Future<List<Reservation>> getReservations(String _itemId);

  /// API-wrapper to request deleting reservations from the database
  Future<void> deleteReservations(List<String> idList);

  /// API-wrapper to request saving reservations to the database
  /// Returns true if the reservation was sucessfull
  Future<void> putReservations(List<Reservation> _reservationList);

  /// API-wrapper to request loading items from the database
  /// provided a list of IDs
  /// If no items are found, an empty list should be returned
  Future<List<Item>> getItems([List<String> idList]);

  /// API-wrapper to request deletion of items from the database
  /// Databases should take care of deleting all linked reservations
  /// before commiting the item deletion
  Future<void> deleteItems(List<String> idList);

  /// API-wrapper to request saving items to the database
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
  /// Hive box for saving items -> lazy because there
  /// might be a significant amount of data stored
  LazyBox<Item> itemCageBox;
  /// Hive box for saving images -> lazy because there
  /// might be a significant amount of data stored
  LazyBox<List<int>> thumbnailCageBox;

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
    _log.d('Opening image box');
    thumbnailCageBox = 
    await Hive.openLazyBox<Uint8List>('imageCagedBox');
  }

  @override
  Future<void> dismiss() async {
    _log.d('Dismissing Hive database manager');
    await categoryCageBox.close();
    await itemCageBox.close();
    await reservationCageBox.close();
    await thumbnailCageBox.close();
  }

  /// Needed for testing to clean-up the boxes
  @visibleForTesting
  Future<void> clear() async {
    _log.d('Clear Hive database manager');
    await categoryCageBox.clear();
    await itemCageBox.clear();
    await reservationCageBox.clear();
    await thumbnailCageBox.clear();
  }

  /// Writing thumbnail image to the local cage
  Future<void> putThumbnail(Uint8List _imageBytes, {String imageId}) async{
    _log.d('Writing thumbnail to Hive');
    thumbnailCageBox.put(LocalIdGenerator()
    .getHiveIdFromString(imageId), _imageBytes);
    return;
  }

  /// Reading thumbnail image from the local cage
  Future<Uint8List> getThumbnail(String imageId) async{
    _log.d('Reading thumbnail from Hive');
    return thumbnailCageBox.get(LocalIdGenerator()
    .getHiveIdFromString(imageId));
  }

  @override
  Future<List<Category>> getCategories() async {
    _log.d('Loading categories from Hive');
    return List<Category>.from(categoryCageBox.toMap().values);
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
      categoryCageBox.put(
        LocalIdGenerator().getHiveIdFromString(_category.id), _category);
    }
    return;
  }

  @override
  Future<List<Reservation>> getReservations(String _itemId) async {
    _log.d('Loading reservations for item $_itemId from Hive');
    var reservationsHive = 
    List<String>.from((await getItems([_itemId]))[0]
    .reservations.map((_id) => 
    LocalIdGenerator().getHiveIdFromString(_id)));
    return Future.wait(
      List.from(
        reservationCageBox.keys.where((_key) => 
        reservationsHive.contains(_key)).map(
          (_key) async {
            var _reservation = await reservationCageBox.get(_key);
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
      await reservationCageBox.put(
        LocalIdGenerator().getHiveIdFromString(_reservation.id), _reservation);
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
  Future<List<Item>> getItems([List<String> idList]) async {
    _log.d('Loading Items $idList from Hive');
    var _itemList = <Item>[];
    for (var _id in idList ?? itemCageBox.keys) {
      /// idList contatins the string keys so they need to be transformed
      /// into the corresponding Hive keys before the call
      var _item = await itemCageBox.get(
        idList == null ? _id : LocalIdGenerator().getHiveIdFromString(_id));
        _itemList.add(_item);
    }
    return _itemList;
  }

  @override
  Future<void> putItems(List<Item> _itemList) async {
    _log.d('Writing items to Hive');
    for(var _item in _itemList){
      await itemCageBox.put(
        LocalIdGenerator().getHiveIdFromString(_item.id), _item);
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