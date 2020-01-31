// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

/// Auto-generated Hive-adapter for the item class
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
      created: fields[9] as DateTime,
      modified: fields[10] as DateTime,
      id: fields[1] as String,
      images: (fields[8] as List)?.cast<String>(),
      reservations: (fields[6] as List)?.cast<String>(),
      categoryId: fields[7] as String,
      active: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(11)
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
      ..write(obj.reservations)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.images)
      ..writeByte(9)
      ..write(obj.created)
      ..writeByte(10)
      ..write(obj.modified);
  }
}
