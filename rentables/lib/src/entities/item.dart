import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../rentables.dart';
import '../services/logger.dart';

part 'item.g.dart';

/// Enum used as keys for search parameters
enum searchParameters {
  /// Key for the category of an item in the search parameters
  category,
  /// Key for the serach-term of an item in the search parameters
  /// this is used for fuzzy-search in the frontend
  searchTerm
}

/// Class handling categories of rentable items
@HiveType(typeId: 3)
class Item extends Equatable{

  /// Is the item still active?
  @HiveField(0)
  final bool active;
  /// Id D of the item
  @HiveField(1)
  final String id;
  /// Name of the item
  @HiveField(2)
  final String title;
  /// Description for the item
  @HiveField(3)
  final String description;
  /// Type of item
  @HiveField(4)
  final String type;
  /// Size of the item
  @HiveField(5)
  final String size;

  /// List of reservations associated with an item
  @HiveField(6)
  final List<String> reservations = [];

  /// ID of the category - used for saving to Hive
  @HiveField(7)
  final String categoryId;

  /// Creation date of the instance
  @HiveField(8)
  final DateTime created;
  /// Date the instance was last modified
  @HiveField(9)
  final DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling categories of rentable items
  Item({
    @required this.size,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.created,
    @required this.modified,
    @required this.id,
    this.categoryId,
    this.active = true,
  }){
    _log.d('Item $id created');
  }

  /// Create a copy of an item and take in changing parameters
  Item copyWith(
    Item _item,
    {
    String size,
    String title,
    String description,
    String type,
    DateTime created,
    DateTime modified,
    String id,
    String categoryId,
    bool active = true,
    }){

    size ??= size;
    title ??= title;
    description ??= description;
    type ??= type;
    categoryId ??= categoryId;
    active ??= active;

    return Item(
      size: size,
      title: title,
      description: description,
      type: type,
      active: active,
      id: _item.id,
      created: _item.created,
      categoryId: categoryId,
      modified: DateTime.now(),
      );
  }

  @override
  List<Object> get props => [id];
}
