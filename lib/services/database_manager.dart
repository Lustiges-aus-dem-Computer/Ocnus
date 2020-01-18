import 'package:hive/hive.dart';
import 'package:oknos/business_logic/category.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oknos/services/local_id_generator.dart';

abstract class DatabaseManager{
  Future<void> initialize();
  Future<void> dismiss();
  Future<List<Category>> getCategories();
  Future<void> putCategories(List<Category> _categoryList);
  Future<void> deleteCategories(List<Category> _categoryList);
}

class HiveManager implements DatabaseManager{
  Box<Category> categoryCageBox;
  LocalIdGenerator _idGenerator;

  // Initialize the hive box
  @override
  Future<void> initialize() async{
    await Hive.initFlutter();
    _idGenerator = new LocalIdGenerator();
    categoryCageBox = await Hive.openBox<Category>('categoryCageBox');
  }

  @override
  Future<void> dismiss() async{
    categoryCageBox.close();
  }

  @override
  getCategories() async{
    List<Category> _categoryList = new List<Category>();
    for(int _id in categoryCageBox.keys.toList()){
      _idGenerator.keyIndex = _id;
      _categoryList.add(categoryCageBox.get(_id));
    }
    return _categoryList;
  }

  @override
  Future<void> putCategories(List<Category> _categoryList) async{
    for(Category _category in _categoryList){
      categoryCageBox.put(_category.hiveId, _category);
    }
    return;
  }

  @override
  Future<void> deleteCategories(List<Category> _categoryList) async{
    for(Category _category in _categoryList){
      categoryCageBox.delete(_category.hiveId);
    }
    return;
  }
}