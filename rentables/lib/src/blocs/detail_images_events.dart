import 'dart:typed_data';

/// Abstract class for events to be handled by the detail-images bloc
abstract class DetailImagesEvent {}

/// Event triggering loading of detail-images
class LoadDetailImages extends DetailImagesEvent {
  /// List if keys for the detail-images that should be loaded
  final List<String> imagesList;
  /// Id of the item the image belongs to
  final String itemId;

  /// Constructor for load detail-images event
  LoadDetailImages({this.imagesList, this.itemId});
}

/// Event triggering addition of a new detail-image
class AddDetailImage extends DetailImagesEvent {
  /// Detail-images to be added
  final Uint8List image;
  /// Id of the item the image belongs to
  final String itemId;

  /// Constructor for new detail-images event
  AddDetailImage({this.image, this.itemId});
}

/// Event triggering deletion of an detail-image
class DeleteDetailImage extends DetailImagesEvent {
  /// Item to be updated
  final String imageId;
  /// Id of the item the image belongs to
  final String itemId;

  /// Constructor for delete detail-image event
  DeleteDetailImage({this.imageId, this.itemId});
}