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
          itemId: event.itemId, imIdTest: event.imIdTest);
    }
    else if(event is DeleteDetailImage){
      yield* _mapDeleteDetailImageToState(imageId: event.imageId,
          itemId: event.itemId);
    }
  }

  Stream<DetailImagesState> _mapLoadDetailImagesToState(
      {String itemId}) async* {
    try {
      var _item = (await repository.loadItems([itemId]))[0];
      var _images =
      await repository.loadDetailImages(_item.images);
      yield DetailImagesLoaded(detailImagesList: _images, itemId: itemId);
    }
    /// In case we have no valid cage / server
    on Exception catch (_) {
      yield DetailImagesNotLoaded();
    }
  }

  Stream<DetailImagesState> _mapAddDetailImageToState({Uint8List image,
      String itemId, String imIdTest}) async* {
    if (state is DetailImagesLoaded) {
      /// Cascade notation
      /// List.from is needed to create a new object
      /// and not alter the state
      final _newImages =
      List<Uint8List>.from((state as DetailImagesLoaded).detailImagesList)
        ..add(image);
      try {
        var _item = (await repository.loadItems([itemId]))[0];
        var _newImageId = imIdTest ?? LocalIdGenerator().getId();
        var _imageIds = _item.images
          ..add(_newImageId);
        /// Save updated list to cage and server (if available)
        await repository.saveDetailImages(keys: [_newImageId],
            imageBytes: [image]);
        /// Update associated item
        await repository.saveItems([_item.copyWith(images: _imageIds)]);
        yield DetailImagesLoaded(detailImagesList: _newImages, itemId: itemId);
      }
      on Exception catch (_) {
        yield DetailImagesUpdateFailed();
      }
    }
  }

  Stream<DetailImagesState> _mapDeleteDetailImageToState({String itemId,
      String imageId}) async* {
    if (state is DetailImagesLoaded) {
      /// Copy so we don't alter the state
      var _newImages = List<Uint8List>
          .from((state as DetailImagesLoaded).detailImagesList);
      var _item = (await repository.loadItems([itemId]))[0];
      var _imageIds = _item.images;
      _newImages.removeAt(_imageIds.indexOf(imageId));
      _imageIds.remove(imageId);
      try {
        /// Delete image from cage and server (if available)
        await repository.deleteDetailImages([imageId]);
        /// Update associated item
        await repository.saveItems([_item.copyWith(images: _imageIds)]);
        yield DetailImagesLoaded(detailImagesList: _newImages,
            itemId: itemId);
      }
      on Exception catch (_) {
        yield DetailImagesUpdateFailed();
      }
    }
  }
}