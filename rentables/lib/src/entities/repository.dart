import '../services/database_manager.dart';
import '../services/logger.dart';
import '../services/reservation_check.dart';
import 'category.dart';
import 'item.dart';
import 'reservation.dart';

/// Abstract class for all types of repositories
abstract class Repository {
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
}

/// Repository for category entires
class CategoryRepository extends Repository {
  final _log = getLogger();

  /// Constructor for repository class
  CategoryRepository(
      {DatabaseManager remoteDatabaseManager,
      DatabaseManager localDatabaseManager})
      : super(
            remoteDatabaseManager: remoteDatabaseManager,
            localDatabaseManager: localDatabaseManager);

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

  /// Call the load-method of the associaded database managers
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

  /// Call the delete-method of the associaded database managers
  Future<void> deleteCategories(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Categories from local database');
      await localDatabaseManager.deleteCategories(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Categories from remote database');
      await remoteDatabaseManager.deleteCategories(idList);
    }
  }
}

/// Repository for reservation entires
class ReservationRepository extends Repository {
  final _log = getLogger();

  /// Constructor for repository class
  ReservationRepository(
      {DatabaseManager remoteDatabaseManager,
      DatabaseManager localDatabaseManager})
      : super(
            remoteDatabaseManager: remoteDatabaseManager,
            localDatabaseManager: localDatabaseManager);

  /// Check if a save-operation could be performed without conflicts
  Future<bool> checkValidUpdate({List<Reservation> reservationList, 
  bool remote}) async {
    _log.d('Checking reservations-update for validity');
    remote ??= remoteDatabaseManager != null;
    /// Check if the reservations to be saved are actually valid
    for(var _reservation in reservationList){
      /// Load all reservations for the relevant item
      if(!checkReservationValidity(existingReservations: 
        await loadReservations(_reservation.item, remote: remote),
        newReservation: _reservation)){
           _log.d('Update NOT valid');
          return false;
          }
    }
    _log.d('Update valid');
    return true;
  }

  /// Call the save-method of the associaded database managers
  Future<void> saveReservations(List<Reservation> _reservationList, 
  {bool forceValid = false}) async {
    var valid = forceValid ? true : await checkValidUpdate(
      reservationList: _reservationList, remote: remoteDatabaseManager != null);
    if(valid){
      if(remoteDatabaseManager != null){
        // Should we be awaiting this?
        _log.d('Saving reservations to remote database');
        await remoteDatabaseManager.putReservations(_reservationList);
      }
      if (localDatabaseManager != null) {
        _log.d('Saving reservations to local database');
        await localDatabaseManager.putReservations(_reservationList);
      }
    }
    return;
  }

  /// Call the load-method of the associaded database managers
  Future<List<Reservation>> loadReservations(Item _item,
  {bool remote = false}) async {
    if (remote) {
      if(remoteDatabaseManager == null){
        _log.e('Requested server update but no remote manager specified');
        throw Exception('No active remote database manager found');
      }
      _log.d('Loading reservations for item ${_item.id} from remote database');
      return remoteDatabaseManager.getReservations(_item);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading reservations for item ${_item.id} from local database');
      return localDatabaseManager.getReservations(_item);
    } else {
      _log.e('Found valid database for loading reservation data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Call the delete-method of the associaded database managers
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
}


/// Repository for rentable items
class ItemRepository extends Repository {
  final _log = getLogger();

  /// Constructor for repository class
  ItemRepository(
      {DatabaseManager remoteDatabaseManager,
      DatabaseManager localDatabaseManager})
      : super(
            remoteDatabaseManager: remoteDatabaseManager,
            localDatabaseManager: localDatabaseManager);

  /// Call the save-method of the associaded database managers
  Future<void> saveItems(List<Item> _itemList) async {
    if (remoteDatabaseManager != null) {
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
      return remoteDatabaseManager.getItems(idList: idList);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading items from local database by list of IDs');
      return localDatabaseManager.getItems(idList: idList);
    } else {
      _log.e('Found valid database for loading item data');
      throw Exception('No valid database manager specified');
    }
  }

  /// Load itmes from box and construct search-keys needed
  /// for fuzzy searching in the UI
  Future<List<String>> getSearchterms() async {
    var _itemList = await loadItems(remote: false);
    var _searchKeys = <String>[];
    for(var _item in _itemList){
      var _title = _item.title;
      var _description = _item.description;
      _searchKeys.add('$_title $_description');
    }
    return _searchKeys;
  }

  /// Call the delete-method of the associaded database managers
  Future<void> deleteItems(List<String> idList) async {
    if (localDatabaseManager != null) {
      _log.d('Delete Items from local database');
      await localDatabaseManager.deleteItems(idList);
    }
    if (remoteDatabaseManager != null) {
      _log.e('Delete Items from remote database');
      await remoteDatabaseManager.deleteItems(idList);
    }
  }
}