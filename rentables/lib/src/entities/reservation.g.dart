// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

/// Auto-generated Hive-adapter for the reservation class
class ReservationAdapter extends TypeAdapter<Reservation> {
  @override
  final int typeId = 1;

  @override
  Reservation read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reservation(
      employee: fields[1] as String,
      customerName: fields[2] as String,
      customerPhone: fields[3] as String,
      customerMail: fields[4] as String,
      startDate: fields[6] as DateTime,
      endDate: fields[7] as DateTime,
      itemId: fields[5] as String,
      created: fields[10] as DateTime,
      modified: fields[11] as DateTime,
      id: fields[0] as String,
      fetchedOn: fields[8] as DateTime,
      returnedOn: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Reservation obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.employee)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.customerPhone)
      ..writeByte(4)
      ..write(obj.customerMail)
      ..writeByte(5)
      ..write(obj.itemId)
      ..writeByte(6)
      ..write(obj.startDate)
      ..writeByte(7)
      ..write(obj.endDate)
      ..writeByte(8)
      ..write(obj.fetchedOn)
      ..writeByte(9)
      ..write(obj.returnedOn)
      ..writeByte(10)
      ..write(obj.created)
      ..writeByte(11)
      ..write(obj.modified);
  }
}
