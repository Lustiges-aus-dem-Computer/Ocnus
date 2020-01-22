// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

/// Hive-Adapter for the Cagtegory class (auto-generated)
class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 0;

  @override
  Category read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      color: fields[4] as String,
      title: fields[2] as String,
      location: fields[3] as String,
      icon: fields[5] as String,
      active: fields[0] as bool,
      id: fields[1] as String,
      created: fields[6] as DateTime,
      modified: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.active)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.icon)
      ..writeByte(6)
      ..write(obj.created)
      ..writeByte(7)
      ..write(obj.modified);
  }
}
