import '../services/database_manager.dart';
import '../services/logger.dart';
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
          'eigther a local or remote database manager');
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
    if (remoteDatabaseManager != null && remote) {
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

  /// Call the save-method of the associaded database managers
  Future<void> saveReservations(List<Reservation> _reservationList) async {
    if (remoteDatabaseManager != null) {
      // Should we be awaiting this?
      _log.d('Saving reservations to remote database');
      await remoteDatabaseManager.putReservations(_reservationList);
    }
    if (localDatabaseManager != null) {
      _log.d('Saving reservations to local database');
      await localDatabaseManager.putReservations(_reservationList);
    }
  }

  /// Call the load-method of the associaded database managers
  Future<List<Reservation>> loadReservations(Item _item,
  {bool remote = false}) async {
    if (remoteDatabaseManager != null && remote) {
      _log.d('Loading reservations for item $_item from remote database');
      return remoteDatabaseManager.getReservations(_item);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading reservations for item $_item from local database');
      return localDatabaseManager.getReservations(_item);
    } else {
      _log.e('Found valid database for loading reservation data');
      throw Exception('No valid database manager specified');
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
  Future<List<Item>> loadItems(List<String> _idList,
  {bool remote = false}) async {
    if (remoteDatabaseManager != null && remote) {
      _log.d('Loading items from remote database by list of IDs');
      return remoteDatabaseManager.getItems(_idList);
    }
    if (localDatabaseManager != null) {
      _log.d('Loading items from local database by list of IDs');
      return localDatabaseManager.getItems(_idList);
    } else {
      _log.e('Found valid database for loading item data');
      throw Exception('No valid database manager specified');
    }
  }
}