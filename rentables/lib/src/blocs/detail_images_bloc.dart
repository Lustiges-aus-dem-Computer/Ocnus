import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rentables.dart';
import '../services/local_id_generator.dart';
import 'detail_images_events.dart';
export 'states.dart';

/// Bloc element (https://bloclibrary.dev/#/) for handling items
class DetailImagesBloc extends Bloc<DetailImagesEvent, DetailImagesState>{
  /// Repository managing the database interactions for items
  final Repository repository;

  /// Constructor for the detail-images bloc element
  DetailImagesBloc({@required this.repository});

  /// Initially, detail-images are still being loaded
  @override
  DetailImagesState get initialState => DetailImagesLoading();

  @override
  Stream<DetailImagesState> mapEventToState(DetailImagesEvent event) async*{
    /// Cannot use switch due to type mismatch
    if(event is LoadDetailImages){
      yield* _mapLoadDetailImagesToState(itemId: event.itemId);
    }
    else if(event is AddDetailImage){
      yield* _mapAddDetailImageToState(image: event.image,
          itemId: event.itemId);
    }
    else if(event is DeleteDetailImage){
      yield* _mapDeleteDetailImageToState(event.imageId);
    }
  }

  Stream<DetailImagesState> _mapLoadDetailImagesToState(
      {String itemId}) async* {
    try {
      var _item = (await repository.loadItems([itemId]))[0];
      var imageIds = _item.images;
      var _images =
      await repository.loadDetailImages(imageIds);
      _images ??= <Uint8List>[];
      yield DetailImagesLoaded(detailImagesList: _images, itemId: itemId,
      imageIds: imageIds);
    }
    /// In case we have no valid cage / server
    on Exception catch (_) {
      yield DetailImagesNotLoaded();
    }
  }

  Stream<DetailImagesState> _mapAddDetailImageToState({Uint8List image,
      String itemId}) async* {
    if (state is DetailImagesLoaded) {
      /// Cascade notation
      /// List.from is needed to create a new object
      /// and not alter the state
      final _newImages =
      List<Uint8List>.from((state as DetailImagesLoaded).detailImagesList)
        ..add(image);
      try {
        var _newImageId = LocalIdGenerator().getId();
        var _imageIds = (state as DetailImagesLoaded).imageIds;
        _imageIds.add(_newImageId);
        /// Save updated list to cage and server (if available)
        await repository.saveDetailImages(keys: [_newImageId],
            imageBytes: [image]);
        /// Update of the associated item is handled by the bloc-supervisor
        yield DetailImagesLoaded(detailImagesList: _newImages,
            itemId: itemId, imageIds: _imageIds);
      }
      on Exception catch (_) {
        yield DetailImagesUpdateFailed();
      }
    }
  }

  Stream<DetailImagesState> _mapDeleteDetailImageToState(
      String _imageId) async* {
    if (state is DetailImagesLoaded) {
      var detailImagesList = (state as DetailImagesLoaded).detailImagesList;
      var imageIds = (state as DetailImagesLoaded).imageIds;
      imageIds.remove(_imageId);
      detailImagesList.removeAt(imageIds.indexOf(_imageId));
      try {
        /// Delete image from cage and server (if available)
        await repository.deleteDetailImages([_imageId]);
        /// Update of the associated item is handled by the bloc-supervisor
        yield DetailImagesLoaded(detailImagesList: detailImagesList,
            imageIds: imageIds,
            itemId: (state as DetailImagesLoaded).itemId);
      }
      on Exception catch (_) {
        yield DetailImagesUpdateFailed();
      }
    }
  }
}