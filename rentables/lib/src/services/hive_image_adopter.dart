import 'package:hive/hive.dart';
import 'package:image/image.dart';

/// Hive adopter for PNG images
class PngAdapter extends TypeAdapter<Image> {
  @override
  final int typeId = 31;

  @override
  Image read(BinaryReader reader) {
    var imageBytes = reader.readByteList();
    return decodeJpg(imageBytes);
  }

  @override
  void write(BinaryWriter writer, Image obj) {
    writer.writeByteList(encodePng(obj));
  }
}

/// Hive adopter for JPEG images
class JpgAdapter extends TypeAdapter<Image> {
  @override
  final int typeId = 32;

  @override
  Image read(BinaryReader reader) {
    var imageBytes = reader.readByteList();
    return decodeJpg(imageBytes);
  }

  @override
  void write(BinaryWriter writer, Image obj) {
    writer.writeByteList(encodeJpg(obj));
  }
}