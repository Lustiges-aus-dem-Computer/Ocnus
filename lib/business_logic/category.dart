import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:oknos/services/local_id_generator.dart';
import 'package:oknos/services/definitions.dart';
import 'package:oknos/services/logger.dart';

part 'category.g.dart';

@HiveType(typeId: 0)
class Category{
  @HiveField(0)
  bool _active;
  @HiveField(1)
  String _id;
  @HiveField(2)
  String _title;
  @HiveField(3)
  String _location;
  @HiveField(4)
  String _color;
  @HiveField(5)
  DateTime created;
  @HiveField(6)
  DateTime modified;
  @HiveField(7)
  String _icon;

  int hiveId;
  final log = getLogger();

  // Two categories are equal if they have the same id
  @override
  bool operator ==(Object other) => other is Category && other.id == _id;

  @override
  int get hashCode => _id.hashCode;  

  Category(
    { 
      @required String color,
      @required String title,
      @required String location,
      @required String icon,
      bool active = true,
      String id,
      DateTime created, 
      DateTime modified,
    }) : 
      this._color = color, 
      this._title = title,
      this._location = location,
      this._icon = icon,
      this._active = active,
      this._id = id ?? LocalIdGenerator().getId(), 
      this.created = created ?? DateTime.now(),
      this.modified = modified ?? DateTime.now()
      {
        if(this.id.length != globalKeyLength){
          int _length = this.id.length;
          log.e('Used an invalid key-length!\nLength used: $_length\nCorrect length: $globalKeyLength');
          throw Exception('Invalid key-length');
        }
        hiveId = LocalIdGenerator().getHiveId(this.id);
      }

  // All setters need to update the modified propterty
  get icon => _icon;
  get title => _title;
  get id => _id;
  get location => _location;
  get color => _color;
  get active => _active;

  void update() => modified = DateTime.now();

  set icon(String valIn){
    _icon = valIn;
    update();
  }
  set title(String valIn){
    _title = valIn;
    update();
  }
  set id(String valIn){
    _id = valIn;
    update();
  }
  set location(String valIn){
    _location = valIn;
    update();
  }
  set color(String valIn){
    _color = valIn;
    update();
  }
  set active(bool valIn){
    _active = valIn;
    update();
  }
  
}