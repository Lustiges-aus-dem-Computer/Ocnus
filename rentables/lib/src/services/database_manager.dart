import 'dart:typed_data';
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
  /// If a category is not found, null should be returned in its position
  Future<List<Category>> getCategories();

  /// API-wrapper to request deleting categories from the database
  Future<void> deleteCategories(List<String> idList);

  /// API-wrapper to request saving categories to the database
  Future<void> putCategories(List<Category> _categoryList);

  /// API-wrapper to request loading reservations for 
  /// a given item from the database
  /// If a reservation is not found, null should be returned in its position
  Future<List<Reservation>> getReservations(String _itemId);

  /// API-wrapper to request deleting reservations from the database
  Future<void> deleteReservations(List<String> idList);

  /// API-wrapper to request saving reservations to the database
  /// Returns true if the reservation was successful
  Future<void> putReservations(List<Reservation> _reservationList);

  /// API-wrapper to request loading items from the database
  /// provided a list of IDs
  /// If an item is not found, null should be returned in its position
  Future<List<Item>> getItems([List<String> idList]);

  /// API-wrapper to request deletion of items from the database
  Future<void> deleteItems(List<String> idList);

  /// API-wrapper to request saving items to the database
  Future<void> putItems(List<Item> _itemList);

  // API-wrapper to request loading images from the database
  /// provided a list of item IDs
  /// If an image is not found, null should be returned in its position
  /// The "thumbnail" switch should be used to indicate whether the
  /// image is a thumbnail or a details image
  Future<List<Uint8List>> getImages(List<String> idList, {bool thumbnail=true});

  /// API-wrapper to request deletion of thumbnails from the database
  /// The "thumbnail" switch should be used to indicate whether the
  /// image is a thumbnail or a details image
  Future<void> deleteImages(List<String> idList, {bool thumbnail=true});

  /// API-wrapper to request saving thumbnails to the database
  /// The "thumbnail" switch should be used to indicate whether the
  /// image is a thumbnail or a details image
  Future<void> putImages({List<String> keys, 
  List<Uint8List> imageBytes, bool thumbnail=true});
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
  /// Hive box for saving thumbnails -> lazy because there
  /// might be a significant amount of data stored
  LazyBox<Uint8List> thumbnailCageBox;
  /// Hive box for saving deatail images -> lazy because there
  /// might be a significant amount of data stored
  LazyBox<Uint8List> detailImagesCageBox;

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
    _log.d('Opening Thumbnail box');
    thumbnailCageBox = 
    await Hive.openLazyBox<Uint8List>('thumbnailCageBox');
    _log.d('Opening Detail-Images box');
    detailImagesCageBox = 
    await Hive.openLazyBox<Uint8List>('detailImagesCageBox');
  }

  @override
  Future<void> dismiss() async {
    _log.d('Dismissing Hive database manager');
    await categoryCageBox.close();
    await itemCageBox.close();
    await reservationCageBox.close();
    await thumbnailCageBox.close();
    await detailImagesCageBox.close();
  }

  /// Needed for testing to clean-up the boxes
  Future<void> clear() async {
    _log.d('Clear Hive database manager');
    await categoryCageBox.clear();
    await itemCageBox.clear();
    await reservationCageBox.clear();
    await thumbnailCageBox.clear();
    await detailImagesCageBox.clear();
  }

  @override
  Future<void> putImages({List<String> keys, 
  List<Uint8List> imageBytes, bool thumbnail=true}) async{

    if(keys == null || imageBytes == null||
    keys.length != imageBytes.length){
      _log.e('Length of keys and images is different when trying'
      'to save thumbnails to hive');
      throw Exception('Inconsistend key and images list lengths');
    }

    _log.d('Writing thumbnails to Hive');
    for(var i=0;i<keys.length; i++){
      var _key = LocalIdGenerator().getHiveIdFromString(keys[i]);
      await (thumbnail
        ?thumbnailCageBox.put(_key, imageBytes[i])
        :detailImagesCageBox.put(_key, imageBytes[i]));
    }
    return;
  }

  Future<List<Uint8List>> getImages(List<String> idList, 
  {bool thumbnail=true})async{
    _log.d('Reading thumbnails from Hive');
    var _box = thumbnail?thumbnailCageBox:detailImagesCageBox;

    var _images = <Uint8List>[];
    for(var _id in idList){
      _images.add(await _box.get(LocalIdGenerator().getHiveIdFromString(_id)));
    }
    return _images;
  }

  Future<void> deleteImages(List<String> idList, 
  {bool thumbnail=true})async{
    _log.d('Deleting thumbnails from Hive');
    var _box = thumbnail?thumbnailCageBox:detailImagesCageBox;
    for(var _id in idList){
      await _box.delete(LocalIdGenerator().getHiveIdFromString(_id));
    }
    return;
  }

  @override
  Future<List<Category>> getCategories() async {
    _log.d('Loading categories from Hive');
    var _categories = List<Category>.from(categoryCageBox.toMap().values);
    return _categories;

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

    var _item = await getItems([_itemId]);
    if(_item.length == 0){
      _log.e('No item found for the reservation');
      throw Exception('Linked item not found!');
    }

    var reservationsHive =
    List<int>.from((await getItems([_itemId]))[0]
    .reservations.map((_id) => 
    LocalIdGenerator().getHiveIdFromString(_id)));

    var _reservations = <Reservation>[];

    for(var _key in reservationCageBox.keys){
      if(reservationsHive.contains(_key)){
        _reservations.add(await reservationCageBox.get(_key));
      }
    }

    return _reservations;
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
      /// idList contains the string keys so they need to be transformed
      /// into the corresponding Hive keys before the call
      _itemList.add(await itemCageBox.get(
        idList == null ? _id : LocalIdGenerator().getHiveIdFromString(_id)));
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