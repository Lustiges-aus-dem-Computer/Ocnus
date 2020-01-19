import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../services/logger.dart';

part 'category.g.dart';

/// Class handling categories of rentable items
@HiveType(typeId: 0)
class Category {
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
  String _icon;

  /// Creation date of the instance
  @HiveField(6)
  DateTime created;
  /// Date the instance was last modified
  @HiveField(7)
  DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling categories of rentable items
  Category({
    @required String color,
    @required String title,
    @required String location,
    @required String icon,
    bool active = true,
    String id,
    DateTime created,
    DateTime modified,
  })  : _color = color,
        _title = title,
        _location = location,
        _icon = icon,
        _active = active,
        _id = id ??
            Uuid().v4(),
        created = DateTime.now(),
        modified = DateTime.now() {
    _log.d('UUID $this.id assigned to category');
    }

  /// Icon used to visualize the category in the UI
  String get icon => _icon;

  /// Name of the category
  String get title => _title;

  /// UUID of the category
  String get id => _id;

  /// Location of the items in this category in the store
  String get location => _location;

  /// Color of the categor in the UI - and in the store?
  String get color => _color;

  /// Is the category active?
  bool get active => _active;

  /// Update the "modified" date after a property was updated
  void update() => modified = DateTime.now();

  /// All setters need to update the modified propterty

  /// Setter for icon created explicitely so modified date is updated
  set icon(String valIn) {
    _icon = valIn;
    update();
  }

  /// Setter for title created explicitely so modified date is  updated
  set title(String valIn) {
    _title = valIn;
    update();
  }

  /// Setter for id created explicitely so modified date is updated
  set id(String valIn) {
    _id = valIn;
    update();
  }

  /// Setter for location created explicitely so modified date is updated
  set location(String valIn) {
    _location = valIn;
    update();
  }

  /// Setter for color created explicitely so modified date is updated
  set color(String valIn) {
    _color = valIn;
    update();
  }

  /// Setter for active-status created explicitely so modified date is updated
  set active(bool valIn) {
    _active = valIn;
    update();
  }
}
