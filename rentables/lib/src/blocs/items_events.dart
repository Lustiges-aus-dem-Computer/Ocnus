import '../entities/item.dart';

/// Abstract class for events to be handled by the items bloc
abstract class ItemsEvent {}

/// Event triggering loading of items from the remote database
class LoadItemsFromServer extends ItemsEvent {
  /// List if keys for the items that should be loaded
  final List<String> itemList;

  /// Constructor for load tiems event
  LoadItemsFromServer(this.itemList);
}

/// Event triggering loading of items
class LoadItemsFromCage extends ItemsEvent {
  /// List if keys for the items that should be loaded
  final List<String> itemList;

  /// Constructor for load tiems event
  LoadItemsFromCage(this.itemList);
}

/// Event triggering loading of items
class LoadItemSearchParameters extends ItemsEvent {}

/// Event triggering addition of a new item
class AddItem extends ItemsEvent {
  /// Item to be added
  final Item item;

  /// Constructor for new item event
  AddItem(this.item);
}

/// Event triggering updating of an item
class UpdateItem extends ItemsEvent {
  /// Item to be updated
  final Item item;

  /// Constructor for update item event
  UpdateItem(this.item);
}

/// Event triggering deletion of an item
class DeleteItem extends ItemsEvent {
  /// Item to be updated
  final Item item;

  /// Constructor for delete item event
  DeleteItem(this.item);
}