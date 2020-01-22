// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

/// Hive-Adapter for the Item class (auto-generated)
class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 3;

  @override
  Item read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      size: fields[5] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      type: fields[4] as String,
      active: fields[0] as bool,
      id: fields[1] as String,
      created: fields[8] as DateTime,
      modified: fields[9] as DateTime,
    )
      ..reservationsHive = (fields[6] as List)?.cast<int>()
      ..categoryId = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.active)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.reservationsHive)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.created)
      ..writeByte(9)
      ..write(obj.modified);
  }
}
