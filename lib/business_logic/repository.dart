import 'package:ocnus/services/database_manager.dart';
import 'package:ocnus/services/logger.dart';
import 'package:ocnus/business_logic/category.dart';
import 'category.dart';
import 'dart:async';


abstract class Repository{
  final _log = getLogger();
  // References the remote database
  final DatabaseManager remoteDatabaseManager;
  //References the local caging database
  final DatabaseManager localDatabaseManager;

  Repository({this.remoteDatabaseManager, this.localDatabaseManager})
    {
      if(remoteDatabaseManager == null && localDatabaseManager == null){
       _log.e('Cannot initialize repository without eigther a local or remote database manager');
        throw Exception('Invalid database manager settings');
      }
    }
}

class CategoryRepository extends Repository{
  final _log = getLogger();
  CategoryRepository({DatabaseManager remoteDatabaseManager, 
  DatabaseManager localDatabaseManager}) : super(remoteDatabaseManager: remoteDatabaseManager, localDatabaseManager: localDatabaseManager);

  Future<void> saveCategories(List<Category> _categoryList) async{
    if(remoteDatabaseManager != null){
      // Should we be awaiting this?
      _log.d('Saving Categories to remote database');
      await remoteDatabaseManager.putCategories(_categoryList);
    }
    if(localDatabaseManager != null){
      _log.d('Saving Categories to local database');
      await localDatabaseManager.putCategories(_categoryList);
    }
  }

  Future<List<Category>> loadCategories({bool remote = false}) async{
    if(remoteDatabaseManager != null && remote){
      _log.d('Loading Categories from remote database');
      return remoteDatabaseManager.getCategories();
    }
    if(localDatabaseManager != null){
      _log.d('Loading Categories from local database');
      return localDatabaseManager.getCategories();
    }
    else{
      _log.e('Found valid database for loading category data');
      throw Exception('No valid database manager specified');
    }
  }
}