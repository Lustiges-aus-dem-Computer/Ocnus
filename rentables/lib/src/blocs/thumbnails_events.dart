/// Abstract class for events to be handled by the thumbnails bloc
abstract class ThumbnailsEvent {}

/// Event triggering loading of thumbnails
class LoadThumbnails extends ThumbnailsEvent {
  /// Number of thumbnails to be added
  final int nAdded;

  /// Constructor for load thumbnails event
  LoadThumbnails(this.nAdded);
}