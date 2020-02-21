import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../rentables.dart';
import 'thumbnails_events.dart';

/// Filtered items bloc class
class ThumbnailsBloc extends Bloc<ThumbnailsEvent, ThumbnailsState> {
  /// Filter item bloc - needed to retrieve filtered items
  final FilteredItemsBloc filteredItemsBloc;
  /// Stream subscription to changes in the filter
  StreamSubscription filterSubscription;
  /// Repository managing the database interactions for thumbnails
  final Repository repository;

  /// Constructor for the filtered items bloc
  ThumbnailsBloc({@required this.filteredItemsBloc,
    @required this.repository}) {
    filterSubscription = filteredItemsBloc.listen((state) {
      if (filteredItemsBloc.state is FilteredItemsLoaded) {
        /// This just re-leads the thumbnails whenever the filter or the items
        /// are updated
        add(LoadThumbnails(0));
      }
    });
  }

  @override
  ThumbnailsState get initialState {
    return filteredItemsBloc.state is FilteredItemsLoaded
        ? ThumbnailsLoaded(thumbnails: repository.loadThumbnails(
        List<String>.from((filteredItemsBloc.state as FilteredItemsLoaded)
            .filteredItemIds.take(4))), nItems: 4)
        : ThumbnailsLoading();
  }

  @override
  Stream<ThumbnailsState> mapEventToState(ThumbnailsEvent event) async* {
    yield* _mapLoadToState(event);
  }

  Stream<ThumbnailsState> _mapLoadToState(ThumbnailsEvent event) async*{
    var nItems = (state as ThumbnailsLoaded).nItems +
        (event as LoadThumbnails).nAdded;

    yield ThumbnailsLoaded(thumbnails: repository.loadThumbnails(
        List<String>.from((filteredItemsBloc.state as FilteredItemsLoaded)
            .filteredItemIds.take(nItems))),
        nItems: nItems);
  }

  @override
  Future<void> close() {
    filterSubscription?.cancel();
    return super.close();
  }
}