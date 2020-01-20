import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/local_id_generator.dart';
import '../services/logger.dart';

part 'category.g.dart';

/// Class handling categories of rentable items
@HiveType(typeId: 0)
class Category{
  final LocalIdGenerator _localIdGen =  LocalIdGenerator();

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

  /// ID used for saving to Hive
  int hiveId;

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
    this.active = true,
    this.id,
    this.created,
    this.modified,
  }){
    created ??= DateTime.now();
    modified ??= DateTime.now();
    id ??= _localIdGen.getId();
    hiveId = _localIdGen.getHiveIdFromString(id);
    _log.d('ID $id assigned to item');
  }

  /// Update the "modified" date after a property was updated
  void update() => modified = DateTime.now();
}
