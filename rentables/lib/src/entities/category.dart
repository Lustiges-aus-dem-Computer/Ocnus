import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/logger.dart';

part 'category.g.dart';

/// Class handling categories of rentable items
@HiveType(typeId: 0)
class Category extends Equatable{
  /// Is the category active
  @HiveField(0)
  final bool active;
  /// ID of the category
  @HiveField(1)
  final String id;
  /// Name of the category
  @HiveField(2)
  final String title;
  /// Location of the category in the store
  @HiveField(3)
  final String location;
  /// Color of the category in the UI
  @HiveField(4)
  final String color;
  /// Icon of the category in the UI
  @HiveField(5)
  final String icon;

  /// Creation date of the instance
  @HiveField(6)
  final DateTime created;
  /// Date the instance was last modified
  @HiveField(7)
  final DateTime modified;

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
    {
      String color,
      String title,
      String location,
      String icon,
      DateTime created,
      DateTime modified,
      bool active,
    }){

    color ??= this.color;
    title ??= this.title;
    location ??= this.location;
    icon ??= this.icon;
    active ??= this.active;

    return Category(
      color: color,
      title: title,
      location: location,
      icon: icon,
      id: id,
      created: this.created,
      active: active,
      modified: DateTime.now(),
      );
  }

  @override
  List<Object> get props => [color, title, location,
    icon, id, created,  modified, active];
}
