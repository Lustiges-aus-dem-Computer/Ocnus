import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/logger.dart';

part 'category.g.dart';

/// Class handling categories of rentable items
@HiveType(typeId: 0)
class Category{
  /// Is the category active
  @HiveField(0)
  bool active;
  /// ID of the category
  @HiveField(1)
  String id;
  /// Name of the category
  @HiveField(2)
  String title;
  /// Location of the category in the store
  @HiveField(3)
  String location;
  /// Color of the category in the UI
  @HiveField(4)
  String color;
  /// Icon of the category in the UI
  @HiveField(5)
  String icon;

  /// Creation date of the instance
  @HiveField(6)
  DateTime created;
  /// Date the instance was last modified
  @HiveField(7)
  DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling categories of rentable items
  Category({
    @required this.color,
    @required this.title,
    @required this.location,
    @required this.icon,
    @required this.id,
    @required this.created,
    @required this.modified,
    this.active = true,
  }){
    _log.d('Category $id created');
  }

 
  /// Create a copy of an item and take in changing parameters
  Category copyWith(
    Category _category,
    {
      String color,
      String title,
      String location,
      String icon,
      DateTime created,
      DateTime modified,
      String id,
      bool active = true,
    }){

    color ??= color;
    title ??= title;
    location ??= location;
    icon ??= icon;
    active ??= active;

    return Category(
      color: color,
      title: title,
      location: location,
      icon: icon,
      id: _category.id,
      created: _category.created,
      active: active,
      modified: DateTime.now(),
      );
  }

  @override
  List<Object> get props => [id];
}
