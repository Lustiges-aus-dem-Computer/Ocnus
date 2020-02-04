import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rentables.dart';
import 'items_events.dart';
export 'states.dart';

/// Bloc element (https://bloclibrary.dev/#/) for handling items
class ItemBloc extends Bloc<ItemsEvent, ItemsState>{
  /// Repository managing the database interactions for items
  final Repository repository;

  /// Constructor for the items bloc element
  ItemBloc({@required this.repository});

  /// Initially, items are still being loaded
  @override
  ItemsState get initialState => ItemsLoading();

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async*{
    /// Cannot use switch due to type mismatch
    if(event is LoadItemsFromCage){
      yield* _mapLoadItemsToState(itemsList: event.itemList, remote: false);
    }
    else if(event is LoadItemsFromServer){
      yield* _mapLoadItemsToState(itemsList: event.itemList, remote: true);
    }
    else if(event is LoadItemSearchParameters){
      yield* _mapLoadSearchParametersToState();
    }
    else if(event is AddItem){
      yield* _mapAddItemToState(event.item);
    }
    else if(event is UpdateItem){
      yield* _mapUpdateItemToState(event.item);
    }
    else if(event is DeleteItem){
      yield* _mapDeleteItemToState(event.item);
    }
  }

  Stream<ItemsState> _mapLoadSearchParametersToState() async* {
    try {
      yield ItemsSearchParametersLoaded(
        await repository.getSearchParameters());
    }
    /// In case we have no valid cage
    on Exception catch (_) {
      yield ItemsNotLoaded();
    }
  }

  Stream<ItemsState> _mapLoadItemsToState(
    {List<String> itemsList, bool remote}) async* {
    try {
      var items = 
      await repository.loadItems(idList: itemsList, remote: remote);
      items ??= <Item>[];
      yield ItemsLoaded(items);
    }
    /// In case we have no valid cage / server
    on Exception catch (_) {
      yield ItemsNotLoaded();
    }
  }

  Stream<ItemsState> _mapAddItemToState(Item _item) async* {
    if (state is ItemsLoaded) {
      /// Cascade notation
      /// List.from is needed to create a new object
      /// and not alter the state
      final _newItems = 
      List<Item>.from((state as ItemsLoaded).itemList)
        ..add(_item);
      try {
        /// Save updated list to cage and server (if available)
        await repository.saveItems([_item]);
        yield ItemsLoaded(_newItems);
      }
      on Exception catch (_) {
        yield ItemsUpdateFailed();
      }
    }
  }

  Stream<ItemsState> _mapUpdateItemToState(Item _item) async* {
    if (state is ItemsLoaded) {
      final _newItems 
      = List<Item>.from(
        (state as ItemsLoaded).itemList.map((_itmTmp) =>
        _itmTmp.id == _item.id ? _item : _itmTmp
        ));
      try {
        /// Save updated list to cage and server (if available)
        await repository.saveItems([_item]);
        yield ItemsLoaded(_newItems);
      }
      on Exception catch (_) {
        yield ItemsUpdateFailed();
      }
    }
  }

  Stream<ItemsState> _mapDeleteItemToState(Item _item) async* {
    if (state is ItemsLoaded) {
      final _newItems 
      = List<Item>.from(
        (state as ItemsLoaded).itemList.where(
          (_itmTmp) => _itmTmp.id != _item.id
        ));
      try {
        /// Delete category from cage and server (if available)
        await repository.deleteItems([_item.id]);
        yield ItemsLoaded(_newItems);
      }
      on Exception catch (_) {
        yield ItemsUpdateFailed();
      }
    }
  }
}