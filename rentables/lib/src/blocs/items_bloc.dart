import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rentables.dart';
import 'items_events.dart';
export 'states.dart';

/// Bloc element (https://bloclibrary.dev/#/) for handling items
class ItemBloc extends Bloc<ItemsEvent, ItemsState>{
  /// Repository managing the database interactions for items
  final ItemRepository itemRepository;

  /// Constructor for the items bloc element
  ItemBloc({@required this.itemRepository});

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
    else if(event is LoadItemSearchTerms){
      yield* _mapLoadSearchTermsToState();
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

  Stream<ItemsState> _mapLoadSearchTermsToState() async* {
    try {
      yield ItemsSearchTermsLoaded(await itemRepository.getSearchterms());
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
      await itemRepository.loadItems(idList: itemsList, remote: remote);
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
      yield ItemsLoaded(_newItems);
      /// Save updated list to cage and server (if available)
      itemRepository.saveItems([_item]);
    }
  }

  Stream<ItemsState> _mapUpdateItemToState(Item _item) async* {
    if (state is ItemsLoaded) {
      final _newItems 
      = List<Item>.from(
        (state as ItemsLoaded).itemList.map((_itmTmp) =>
        _itmTmp.id == _item.id ? _item : _itmTmp
        ));
      yield ItemsLoaded(_newItems);
      /// Save updated list to cage and server (if available)
      itemRepository.saveItems([_item]);
    }
  }

  Stream<ItemsState> _mapDeleteItemToState(Item _item) async* {
    if (state is ItemsLoaded) {
      final _newItems 
      = List<Item>.from(
        (state as ItemsLoaded).itemList.where(
          (_itmTmp) => _itmTmp.id != _item.id
        ));
      yield ItemsLoaded(_newItems);
      /// Delete category from cage and server (if available)
      itemRepository.deleteItems([_item.id]);
    }
  }
}