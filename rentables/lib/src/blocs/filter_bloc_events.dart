/// Abstract class for filtered items
abstract class FilteredItemsEvent{
  /// Super constructor for the filter
  const FilteredItemsEvent();
}

/// Update the categories to be filtered by
class UpdateFilter extends FilteredItemsEvent {
  /// Search string used for the fuzzy search
  final List<String> categoryIds;
  /// Search string for the filter
  final String searchString;

  /// Constructor for the update filter event
  const UpdateFilter({this.categoryIds, this.searchString});
}

/// Update items
class UpdateItems extends FilteredItemsEvent {
  /// Filtered items
  final List<String> itemIds;

  /// Constructor for the update filtered items class
  const UpdateItems(this.itemIds);
}