// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final typeId = 0;

  @override
  Category read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category()
      .._active = fields[0] as bool
      .._id = fields[1] as String
      .._title = fields[2] as String
      .._location = fields[3] as String
      .._color = fields[4] as String
      .._icon = fields[5] as String
      ..created = fields[6] as DateTime
      ..modified = fields[7] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._active)
      ..writeByte(1)
      ..write(obj._id)
      ..writeByte(2)
      ..write(obj._title)
      ..writeByte(3)
      ..write(obj._location)
      ..writeByte(4)
      ..write(obj._color)
      ..writeByte(5)
      ..write(obj._icon)
      ..writeByte(6)
      ..write(obj.created)
      ..writeByte(7)
      ..write(obj.modified);
  }
}
