// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReservationAdapter extends TypeAdapter<Reservation> {
  @override
  final typeId = 1;

  @override
  Reservation read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reservation()
      .._id = fields[0] as String
      .._employee = fields[1] as String
      .._customerName = fields[2] as String
      .._customerPhone = fields[3] as String
      .._customerMail = fields[4] as String
      .._startDate = fields[5] as DateTime
      .._endDate = fields[6] as DateTime
      .._fetchedOn = fields[7] as DateTime
      .._returnedOn = fields[8] as DateTime
      ..created = fields[9] as DateTime
      ..modified = fields[10] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Reservation obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._employee)
      ..writeByte(2)
      ..write(obj._customerName)
      ..writeByte(3)
      ..write(obj._customerPhone)
      ..writeByte(4)
      ..write(obj._customerMail)
      ..writeByte(5)
      ..write(obj._startDate)
      ..writeByte(6)
      ..write(obj._endDate)
      ..writeByte(7)
      ..write(obj._fetchedOn)
      ..writeByte(8)
      ..write(obj._returnedOn)
      ..writeByte(9)
      ..write(obj.created)
      ..writeByte(10)
      ..write(obj.modified);
  }
}
