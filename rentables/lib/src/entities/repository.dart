import 'dart:typed_data';

import '../services/connectivity.dart';
import '../services/database_manager.dart';
import '../services/logger.dart';
import '../services/reservation_check.dart';
import 'category.dart';
import 'item.dart';
import 'reservation.dart';

/// Abstract class for all types of repositories
class Repository {
  final _log = getLogger();
  /// Class for checking app-connectivity
  final Connectivity connectivity;

  /// References the remote database
  final DatabaseManager remoteDatabaseManager;

  /// References the local caging database
  final DatabaseManager localDatabaseManager;

  /// Constructor for abstract repository class
  Repository({this.remoteDatabaseManager, this.localDatabaseManager,
  this.connectivity}) {
    if (remoteDatabaseManager == null && localDatabaseManager == null) {
      _log.e('Cannot initialize repository without'
          ' eigther a local or remote database manager');
      throw Exception('Invalid database manager settings');
    }
  }

  /// Call the save-method of the associated database managers
  Future<void> saveCategories(List<Category> _categoryList) async {
    if (remoteDatabaseManager != null) {
      _log.d('Saving Categories to remote database');
      remoteDatabaseManager.putCategories(_categoryList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving Categories to local database');
      localDatabaseManager.putCategories(_categoryList);
    }
  }

  /// Call the load-method of the associated database managers
  Future<List<Category>> loadCategories() async {
    /// If we are online, we load the reservations from the server
    if(await connectivity.isOnline() && remoteDatabaseManager != null){
      return remoteDatabaseManager.getCategories();
    }
    else{
      return localDatabaseManager.getCategories();
    }
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteCategories(List<String> idList) async {
    /// Remove category-entries from all items that reference it
    /// Add the new reservation to the item and save it
    var _itemList = List <Item>.from((await loadItems())
    .where((_item) => idList.contains(_item.categoryId)));

    for(var i=0; i<_itemList.length; i++){
      _itemList[i] = _itemList[i].copyWith(categoryId: null);
    }

    await saveItems(_itemList);

    if (localDatabaseManager != null) {
      _log.d('Delete Categories from local database');
      localDatabaseManager.deleteCategories(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Categories from remote database');
      remoteDatabaseManager.deleteCategories(idList);
    }
  }

  /// Check if a save-operation can be performed without conflicts
  Future<List<bool>> checkValidUpdate(List<Reservation> reservationList) async {
    var _valid = <bool>[];
    _log.d('Checking reservations-update for validity');
    /// Check if the reservations to be saved are actually valid
    for(var _reservation in reservationList) {
      /// Load all reservations for the relevant item
      _valid.add(checkReservationValidity(existingReservations:
      await loadReservations(_reservation.itemId),
          newReservation: _reservation));
    }
    return _valid;
  }

  /// Call the save-method of the associated database managers
  Future<void> saveReservations(List<Reservation> _reservationList) async {
    /// Add the new reservation to the item and save it
    var _itemList = await loadItems(List <String>
        .from(_reservationList.map((_res) => _res.itemId)));

    for(var i=0; i<_itemList.length; i++){
      if(!_itemList[i].reservations.contains(_reservationList[i].id)){
        _itemList[i].reservations.add(_reservationList[i].id);
      }
    }

    await saveItems(_itemList);

    if(remoteDatabaseManager != null){
      _log.d('Saving reservations to remote database');
      remoteDatabaseManager.putReservations(_reservationList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving reservations to local database');
      localDatabaseManager.putReservations(_reservationList);
    }
    return;
  }

  /// Call the load-method of the associated database managers
  Future<List<Reservation>> loadReservations(String _itemId) async {
    /// If we are online, we load the reservations from the server
    if(await connectivity.isOnline() && remoteDatabaseManager != null){
      return remoteDatabaseManager.getReservations(_itemId);
    }
    else{
      return localDatabaseManager.getReservations(_itemId);
    }
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteReservations(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Reservations from local database');
      localDatabaseManager.deleteReservations(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Reservations from remote database');
      remoteDatabaseManager.deleteReservations(idList);
    }
  }
  
  /// Call the save-method of the associated database managers
  Future<void> saveItems(List<Item> _itemList) async {
    if (remoteDatabaseManager != null) {
      _log.d('Saving items to remote database');
      remoteDatabaseManager.putItems(_itemList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving items to local database');
      localDatabaseManager.putItems(_itemList);
    }
  }

  /// Call the load-method of the associated database managers
  Future<List<Item>> loadItems([List<String> idList]) async {
    /// If we are online, we load the items from the server
    if(await connectivity.isOnline() && remoteDatabaseManager != null){
      return remoteDatabaseManager.getItems(idList);
    }
    else{
      return localDatabaseManager.getItems(idList);
    }
  }

  /// Load items from box and construct search-keys needed
  /// for fuzzy searching in the UI
  Future<Map<String,Map<searchParameters, String>>> 
  getSearchParameters() async {
    var _itemList = await loadItems();
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
    for(var _item in await loadItems(idList)){
      await deleteReservations(_item.reservations);
    }

    if (localDatabaseManager != null) {
      _log.d('Delete Items from local database');
      localDatabaseManager.deleteItems(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Items from remote database');
      remoteDatabaseManager.deleteItems(idList);
    }
  }

  /// Call the save-method of the associated database managers
  Future<void> saveDetailImages({List<String> keys, 
  List<Uint8List> imageBytes}) async {
    if (remoteDatabaseManager != null) {
      _log.d('Saving Categories to remote database');
      remoteDatabaseManager.putImages(keys: keys,
      imageBytes: imageBytes, thumbnail: false);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving Categories to local database');
      localDatabaseManager.putImages(keys: keys,
      imageBytes: imageBytes, thumbnail: false);
    }
  }

  /// Call the load-method of the associated database managers
  Future<List<Uint8List>> loadDetailImages(List<String> idList) async {
    /// If we are online, we load the items from the server
    if(await connectivity.isOnline() && remoteDatabaseManager != null){
      return remoteDatabaseManager.getImages(idList, thumbnail: false);
    }
    else{
      return localDatabaseManager.getImages(idList, thumbnail: false);
    }
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteDetailImages(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Images from local database');
      localDatabaseManager.deleteImages(idList, thumbnail: false);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Images from remote database');
      remoteDatabaseManager.deleteImages(idList, thumbnail: false);
    }
  }

  /// Call the save-method of the associated database managers
  Future<void> saveThumbnails({List<String> keys, 
  List<Uint8List> imageBytes}) async {
    if (remoteDatabaseManager != null) {
      _log.d('Saving Categories to remote database');
      remoteDatabaseManager.putImages(keys: keys,
      imageBytes: imageBytes, thumbnail: true);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving Categories to local database');
      localDatabaseManager.putImages(keys: keys,
      imageBytes: imageBytes, thumbnail: true);
    }
  }

  /// Call the load-method of the associaded database managers
  Future<List<Uint8List>> loadThumbnails(List<String> idList) async {
    /// If we are online, we load the items from the server
    if(await connectivity.isOnline() && remoteDatabaseManager != null){
      return remoteDatabaseManager.getImages(idList, thumbnail: true);
    }
    else{
      return localDatabaseManager.getImages(idList, thumbnail: true);
    }
  }

  /// Call the delete-method of the associated database managers
  Future<void> deleteThumbnails(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Images from local database');
      localDatabaseManager.deleteImages(idList, thumbnail: true);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Images from remote database');
      remoteDatabaseManager.deleteImages(idList, thumbnail: true);
    }
  }

}