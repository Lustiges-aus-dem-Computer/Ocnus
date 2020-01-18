import '../services/database_manager.dart';
import '../services/logger.dart';
import 'category.dart';

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
