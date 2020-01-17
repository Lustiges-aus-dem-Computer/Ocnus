import 'package:oknos/services/database_manager.dart';
import 'package:oknos/services/logger.dart';

abstract class Repository{
  final _log = getLogger();
  // References the remote database
  final DatabaseManager _remoteDatabaseManager;
  //References the local caging database
  final DatabaseManager _localDatabaseManager;

  Repository({DatabaseManager remoteDatabaseManager, 
  DatabaseManager localDatabaseManager}) : 
  this._remoteDatabaseManager = remoteDatabaseManager, 
  this._localDatabaseManager = localDatabaseManager{
    if(_remoteDatabaseManager == null && _localDatabaseManager == null){
      _log.e('Cannot initialize repository without eigther a local or remote database manager');
      throw Exception('Invalid database manager settings');
    }
  }


}

class CategoryRepository extends Repository{
  
}