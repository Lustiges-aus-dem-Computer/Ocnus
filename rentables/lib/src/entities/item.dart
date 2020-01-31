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
  /// Key for the search-term of an item in the search parameters
  /// this is used for fuzzy-search in the frontend
  searchTerm
}

/// Actions to be performed on the category ID linked to an item
enum catIdActions {
  /// Delete the category ID
  deleteCat,
  /// Update the category ID
  updateCat
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
  final List<String> reservations;

  /// ID of the category - used for saving to Hive
  @HiveField(7)
  final String categoryId;

  /// List of images for the item
  /// Thumbnail is saved directly with the item ID
  @HiveField(8)
  final List<String> images;

  /// Creation date of the instance
  @HiveField(9)
  final DateTime created;
  /// Date the instance was last modified
  @HiveField(10)
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
    @required this.images,
    this.reservations,
    this.categoryId,
    this.active = true,
  }){
    _log.d('Item $id created');
  }

  /// Delete the category ID from the Item and return a new item
  Item deleteCategory(){
    return copyWith(catAction: catIdActions.deleteCat);
  }

  /// Create a copy of an item and take in changing parameters
  Item copyWith(
    {
      catIdActions catAction = catIdActions.updateCat,
      String size,
      String title,
      String description,
      String type,
      List<String> images,
      DateTime created,
      DateTime modified,
      List<String> reservations,
      String categoryId,
      bool active = true,
    }){

    size ??= this.size;
    catAction == catIdActions.updateCat
        ?categoryId ??= this.categoryId
        :categoryId = null;
    images ??= this.images;
    reservations ??= this.reservations;
    title ??= this.title;
    description ??= this.description;
    type ??= this.type;
    active ??= this.active;
    /// We don't check the category ID so it can be set to null

    return Item(
      size: size,
      title: title,
      description: description,
      type: type,
      images: images,
      reservations: reservations,
      active: active,
      id: id,
      created: this.created,
      categoryId: categoryId,
      modified: DateTime.now(),
      );
  }

  @override
  List<Object> get props => [size, title, description, type, created, modified,
  id, images, reservations, categoryId, active];
}
