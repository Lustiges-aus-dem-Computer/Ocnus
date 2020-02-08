import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

/// Abstract class for events to be handled by the detail-images bloc
abstract class DetailImagesEvent {}

/// Event triggering loading of detail-images
class LoadDetailImages extends DetailImagesEvent {
  /// Id of the item the image belongs to
  final String itemId;

  /// Constructor for load detail-images event
  LoadDetailImages(this.itemId);
}

/// Event triggering addition of a new detail-image
class AddDetailImage extends DetailImagesEvent {
  /// Detail-images to be added
  final Uint8List image;
  /// Id of the item the image belongs to
  final String itemId;
  /// Used for testing te set the image-id from outside
  final String imIdTest;

  /// Constructor for new detail-images event
  AddDetailImage({@required this.image, @required this.itemId, this.imIdTest});
}

/// Event triggering deletion of an detail-image
class DeleteDetailImage extends DetailImagesEvent {
  /// Item to be updated
  final String imageId;
  /// Id of the item the image belongs to
  final String itemId;

  /// Constructor for delete detail-image event
  DeleteDetailImage({@required this.imageId, @required this.itemId});
}