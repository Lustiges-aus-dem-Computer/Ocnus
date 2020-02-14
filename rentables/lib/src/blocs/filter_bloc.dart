import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:flutter/cupertino.dart';
import '../../rentables.dart';

/// Filtered items bloc class
class FilteredItemsBloc extends Bloc<FilteredItemsEvent, FilteredItemsState> {
  /// Items bloc - needed to retrieve items
  final ItemBloc itemBloc;
  /// Stream subscription to changes in the items
  StreamSubscription itemsSubscription;

  /// Constructor for the filtered items bloc
  FilteredItemsBloc({@required this.itemBloc}) {
    itemsSubscription = itemBloc.listen((state) {
      if (itemBloc.state is ItemsSearchParametersLoaded) {
        add(UpdateItems((itemBloc.state
        as ItemsSearchParametersLoaded).itemSearchParameters.keys));
      }
    });
  }

  @override
  FilteredItemsState get initialState {
    return itemBloc.state is ItemsSearchParametersLoaded
        ? FilteredItemsLoaded(filteredItemIds:
      (itemBloc.state as ItemsSearchParametersLoaded).itemSearchParameters.keys,
    categoryIds: [],
    searchString: '')
        : FilteredItemsLoading();
  }

  @override
  Stream<FilteredItemsState> mapEventToState(FilteredItemsEvent event) async* {
      if (event is UpdateFilter) {
        yield* _mapUpdateFilterToState(event);
      } else if (event is UpdateItems) {
        yield* _maUpdateItemsToState(event);
      }
    }

  Stream<FilteredItemsState> _maUpdateItemsToState(UpdateItems event) async* {
    var _categoryIds = (state as FilteredItemsLoaded).categoryIds;
    var _searchString = (state as FilteredItemsLoaded).searchString;
    yield FilteredItemsLoaded(
      categoryIds: _categoryIds,
      searchString: _searchString,
      filteredItemIds: await _applyItemFilters(categoryIds: _categoryIds,
        searchString: _searchString)
    );
  }

  Future<List<String>> _applyItemFilters({List<String> categoryIds,
    String searchString}) async{
    var _searchParameters = itemBloc.state is ItemsSearchParametersLoaded
        ?(itemBloc.state as ItemsSearchParametersLoaded).itemSearchParameters
        :((await itemBloc.add(LoadItemSearchParameters()))
    as ItemsSearchParametersLoaded).itemSearchParameters;

    var _idsByCategory = categoryIds.length == 0
        ?List<String>.from(_searchParameters.keys)
        :<String>[];

    if(_idsByCategory.length != List<String>
        .from(_searchParameters.keys).length) {
      for (var _key in _searchParameters.keys) {
        if (categoryIds
            .contains(_searchParameters[_key][searchParameters.category])) {
          _idsByCategory.add(_key);
        }
      }
    }

    var _searchStings;
    if(searchString.length >=4) {
      _searchStings = List<String>.from(
          _idsByCategory.map((_key) => _searchParameters[_key][searchParameters
              .searchTerm]));
    }

    /// Fuzzy search options are set globally
    var _searchResults = searchString.length < 4
        ?_idsByCategory
        :Fuzzy(_searchStings, options: fuzzySearchOptions).search(searchString)
        .map((_result) => _result.item as String);

    return List<String>.from(_searchResults.map((_result) =>
        _idsByCategory[_searchStings
            .indexWhere((_element) => _element == _result)]));
  }

  Stream<FilteredItemsState> _mapUpdateFilterToState(UpdateFilter event) async*{
    var _categoryIds = event.categoryIds == null
    ?(state as FilteredItemsLoaded).categoryIds :event.categoryIds;
    var _searchString = event.searchString == null
    ?(state as FilteredItemsLoaded).searchString :event.searchString;

    if (state is FilteredItemsLoaded) {
      yield FilteredItemsLoaded(
        categoryIds: _categoryIds,
        searchString: _searchString,
        filteredItemIds: await _applyItemFilters(categoryIds: _categoryIds,
          searchString: _searchString)
      );
    }
  }

  @override
  Future<void> close() {
    itemsSubscription.cancel();
    return super.close();
  }
}