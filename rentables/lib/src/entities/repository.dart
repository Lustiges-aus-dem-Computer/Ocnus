import 'dart:typed_data';

import '../services/database_manager.dart';
import '../services/logger.dart';
import '../services/reservation_check.dart';
import 'category.dart';
import 'item.dart';
import 'reservation.dart';

/// Abstract class for all types of repositories
class Repository {
  final _log = getLogger();

  /// References the remote database
  final DatabaseManager remoteDatabaseManager;

  /// References the local caging database
  final DatabaseManager localDatabaseManager;

  /// Constructor for abstract repository class
  Repository({this.remoteDatabaseManager, this.localDatabaseManager}) {
    if (remoteDatabaseManager == null && localDatabaseManager == null) {
      _log.e('Cannot initialize repository without'
          ' eigther a local or remote database manager');
      throw Exception('Invalid database manager settings');
    }
  }

  /// Call the save-method of the associaded database managers
  Future<void> saveCategories(List<Category> _categoryList) async {
    if (remoteDatabaseManager != null) {
      // Should we be awaiting this?
      _log.d('Saving Categories to remote database');
      await remoteDatabaseManager.putCategories(_categoryList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving Categories to local database');
      await localDatabaseManager.putCategories(_categoryList);
    }
  }

  /// Call the load-method of the associated database managers
  Future<List<Category>> loadCategories({bool remote = false}) async {
    if (remote) {
      if(remoteDatabaseManager == null){
        _log.e('Requested server update but no remote manager specified');
        throw Exception('No active remote database manager found');
      }
      _log.d('Loading Categories from remote database');
      return remoteDatabaseManager.getCategories();
    }
    if (localDatabaseManager != null) {
      _log.d('Loading Categories from local database');
      return localDatabaseManager.getCategories();
    } else {
      _log.e('Found valid database for loading category data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteCategories(List<String> idList) async {
    /// Remove category-entries from all items that reference it
    /// Add the new reservation to the item and save it
    var _itemList = List <Item>.from((await loadItems())
    .where((_item) => idList.contains(_item.categoryId)));

    for(var i=0; i<_itemList.length; i++){
      _itemList[i] = _itemList[i].deleteCategory();
    }

    await saveItems(_itemList);

    if (localDatabaseManager != null) {
      _log.d('Delete Categories from local database');
      await localDatabaseManager.deleteCategories(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Categories from remote database');
      await remoteDatabaseManager.deleteCategories(idList);
    }
  }

  /// Check if a save-operation could be performed without conflicts
  Future<bool> checkValidUpdate({List<Reservation> reservationList, 
  bool remote}) async {
    _log.d('Checking reservations-update for validity');
    remote ??= remoteDatabaseManager != null;
    /// Check if the reservations to be saved are actually valid
    for(var _reservation in reservationList){
      /// Load all reservations for the relevant item
      if(!checkReservationValidity(existingReservations: 
        await loadReservations(_reservation.itemId, remote: remote),
        newReservation: _reservation)){
           _log.d('Update NOT valid');
          return false;
          }
    }
    _log.d('Update valid');
    return true;
  }

  /// Call the save-method of the associated database managers
  Future<void> saveReservations(List<Reservation> _reservationList) async {
    /// Add the new reservation to the item and save it
    var _itemList = await loadItems(idList:
    List <String>.from(_reservationList.map((_res) => _res.itemId)),
    remote: !(remoteDatabaseManager == null));

    for(var i=0; i<_itemList.length; i++){
      if(!_itemList[i].reservations.contains(_reservationList[i].id)){
        _itemList[i].reservations.add(_reservationList[i].id);
      }
    }

    await saveItems(_itemList, cageOnly: true);

    if(remoteDatabaseManager != null){
      // Should we be awaiting this?
      _log.d('Saving reservations to remote database');
      await remoteDatabaseManager.putReservations(_reservationList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving reservations to local database');
      await localDatabaseManager.putReservations(_reservationList);
    }
    return;
  }

  /// Call the load-method of the associated database managers
  Future<List<Reservation>> loadReservations(String _itemId,
  {bool remote = false}) async {
    if (remote) {
      if(remoteDatabaseManager == null){
        _log.e('Requested server update but no remote manager specified');
        throw Exception('No active remote database manager found');
      }
      _log.d('Loading reservations for item $_itemId from remote database');
      return remoteDatabaseManager.getReservations(_itemId);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading reservations for item $_itemId from local database');
      return localDatabaseManager.getReservations(_itemId);
    } else {
      _log.e('Found valid database for loading reservation data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteReservations(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Reservations from local database');
      await localDatabaseManager.deleteReservations(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Reservations from remote database');
      await remoteDatabaseManager.deleteReservations(idList);
    }
  }
  
  /// Call the save-method of the associaded database managers
  Future<void> saveItems(List<Item> _itemList, {bool cageOnly = false}) async {
    if (remoteDatabaseManager != null ?? ! cageOnly) {
      // Should we be awaiting this?
      _log.d('Saving items to remote database');
      await remoteDatabaseManager.putItems(_itemList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving items to local database');
      await localDatabaseManager.putItems(_itemList);
    }
  }

  /// Call the load-method of the associaded database managers
  Future<List<Item>> loadItems({List<String> idList,
  bool remote = false}) async {
    if (remote) {
      if(remoteDatabaseManager == null){
        _log.e('Requested server update but no remote manager specified');
        throw Exception('No active remote database manager found');
      }
      _log.d('Loading items from remote database by list of IDs');
      return remoteDatabaseManager.getItems(idList);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading items from local database by list of IDs');
      return localDatabaseManager.getItems(idList);
    } else {
      _log.e('Found valid database for loading item data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Load itmes from box and construct search-keys needed
  /// for fuzzy searching in the UI
  Future<Map<String,Map<searchParameters, String>>> 
  getSearchParameters() async {
    var _itemList = await loadItems(remote: false);
    var _searchParameters = <String,Map<searchParameters, String>>{};
    for(var _item in _itemList){
      _searchParameters[_item.id] = {
        searchParameters.category: _item.categoryId,
        searchParameters.searchTerm: '${_item.title} ${_item.description}'};
    }
    return _searchParameters;
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteItems(List<String> idList) async {
    /// Delete reservations associated with the deleted item
    for(var _item in await loadItems(idList: idList)){
      await deleteReservations(_item.reservations);
    }

    if (localDatabaseManager != null) {
      _log.d('Delete Items from local database');
      await localDatabaseManager.deleteItems(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Items from remote database');
      await remoteDatabaseManager.deleteItems(idList);
    }
  }

  /// Call the save-method of the associated database managers
  Future<void> saveImages({List<String> keys, 
  List<Uint8List> imageBytes}) async {
    if (remoteDatabaseManager != null) {
      // Should we be awaiting this?
      _log.d('Saving Categories to remote database');
      await remoteDatabaseManager.putImages(keys: keys, 
      imageBytes: imageBytes, thumbnail: false);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving Categories to local database');
      await localDatabaseManager.putImages(keys: keys, 
      imageBytes: imageBytes, thumbnail: false);
    }
  }

  /// Call the load-method of the associaded database managers
  Future<List<Uint8List>> loadImages(List<String> idList, 
  {bool remote = false}) async {
    if (remote) {
      if(remoteDatabaseManager == null){
        _log.e('Requested server update but no remote manager specified');
        throw Exception('No active remote database manager found');
      }
      _log.d('Loading Images from remote database');
      return remoteDatabaseManager.getImages(idList, thumbnail: false);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading Images from local database');
      return localDatabaseManager.getImages(idList, thumbnail: false);
    } else {
      _log.e('Found valid database for loading category data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Call the delete-method of the associaded database managers
  Future<void> deleteImages(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Images from local database');
      await localDatabaseManager.deleteImages(idList, thumbnail: false);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Images from remote database');
      await remoteDatabaseManager.deleteImages(idList, thumbnail: false);
    }
  }

  /// Call the save-method of the associaded database managers
  Future<void> saveThumbnails({List<String> keys, 
  List<Uint8List> imageBytes}) async {
    if (remoteDatabaseManager != null) {
      // Should we be awaiting this?
      _log.d('Saving Categories to remote database');
      await remoteDatabaseManager.putImages(keys: keys, 
      imageBytes: imageBytes, thumbnail: true);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving Categories to local database');
      await localDatabaseManager.putImages(keys: keys, 
      imageBytes: imageBytes, thumbnail: true);
    }
  }

  /// Call the load-method of the associaded database managers
  Future<List<Uint8List>> loadThumbnails(List<String> idList, 
  {bool remote = false}) async {
    if (remote) {
      if(remoteDatabaseManager == null){
        _log.e('Requested server update but no remote manager specified');
        throw Exception('No active remote database manager found');
      }
      _log.d('Loading Images from remote database');
      return remoteDatabaseManager.getImages(idList, thumbnail: true);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading Images from local database');
      return localDatabaseManager.getImages(idList, thumbnail: true);
    } else {
      _log.e('Found valid database for loading category data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Call the delete-method of the associaded database managers
  Future<void> deleteThumbnails(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Images from local database');
      await localDatabaseManager.deleteImages(idList, thumbnail: true);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Images from remote database');
      await remoteDatabaseManager.deleteImages(idList, thumbnail: true);
    }
  }

}