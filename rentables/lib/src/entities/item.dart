import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../rentables.dart';
import '../services/local_id_generator.dart';
import '../services/logger.dart';

part 'item.g.dart';

/// Class handling categories of rentable items
@HiveType(typeId: 3)
class Item {
  final LocalIdGenerator _localIdGen =  LocalIdGenerator();

  /// Is the item still active?
  @HiveField(0)
  bool active;
  /// Id D of the item
  @HiveField(1)
  String id;
  /// Name of the item
  @HiveField(2)
  String title;
  /// Description for the item
  @HiveField(3)
  String description;
  /// Type of item
  @HiveField(4)
  String type;
  /// Size of the item
  @HiveField(5)
  String size;

  /// List of reservations associated with an item
  List<Reservation> reservations = [];

  /// List of reservations associated with an item for Hive saving
  @HiveField(6)
  List<int> reservationsHive = [];

  /// Link to item-category
  Category category;

  /// ID of the category - used for saving to Hive
  @HiveField(7)
  String categoryId;

  /// ID used for saving to Hive
  int hiveId;

  /// Creation date of the instance
  @HiveField(8)
  DateTime created;
  /// Date the instance was last modified
  @HiveField(9)
  DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling categories of rentable items
  Item({
    @required this.size,
    @required this.title,
    @required this.description,
    @required this.type,
    this.category,
    this.active = true,
    this.id,
    this.created,
    this.modified,
  }){
    created ??= DateTime.now();
    modified ??= DateTime.now();
    id ??= _localIdGen.getId();
    hiveId = _localIdGen.getHiveIdFromString(id);
    if(category != null){categoryId = category.id;}
    _log.d('ID $id assigned to item');

    ///Types should only be of length 1
    if(!'mdfc'.contains(type) || type.length != 1){
      _log.e('Item-Types should only be one of the folowing: m/d/f/c');
      throw Exception('Invalid length of type-parameter');
    }
  }

  /// Update the "modified" date after a property was updated
  void update(){
    if(category != null){categoryId = category.id;}
    modified = DateTime.now();
    }
}
