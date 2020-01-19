import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/definitions.dart';
import '../services/local_id_generator.dart';
import '../services/logger.dart';
import 'item.dart';

part 'reservation.g.dart';

/// Class handling reservations of rentable items
@HiveType(typeId: 1)
class Reservation {
  final LocalIdGenerator _localIdGen =  LocalIdGenerator();

  /// ID of the reservation
  @HiveField(0)
  String id;
  /// Name of the employee who created the reservation
  @HiveField(1)
  String employee;
  /// Name of the customer requesting the reservation
  @HiveField(2)
  String customerName;
  /// Phone number of the customer requesting the reservation
  @HiveField(3)
  String customerPhone;
  /// Email address of the customer requesting the reservation
  @HiveField(4)
  String customerMail;

  /// Link to the item the reservation is linked to
  Item item;

  /// ID of the item - used for saving to Hive
  @HiveField(5)
  String itemId;

  /// ID used for saving to Hive
  int hiveId;

  /// Start date of the reservation
  @HiveField(6)
  DateTime startDate;
  /// End date of the reservation
  @HiveField(7)
  DateTime endDate;
  /// Date the reserved item was picked up
  @HiveField(8)
  DateTime fetchedOn;
  /// Date the reserved item was returned
  @HiveField(9)
  DateTime returnedOn;

  /// Creation date of the instance
  @HiveField(10)
  DateTime created;
  /// Date the instance was last modified
  @HiveField(11)
  DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling reservations of rentable items
  Reservation({
    @required this.employee,
    @required this.customerName,
    @required this.customerPhone,
    @required this.customerMail,
    this.item,
    @required this.startDate,
    @required this.endDate,
    this.fetchedOn,
    this.returnedOn,
    this.id,
    this.created,
    this.modified,
  }){
    created ??= DateTime.now();
    modified ??= DateTime.now();
    id ??= _localIdGen.getId();
    if(item != null){itemId = item.id;}
    hiveId = _localIdGen.getHiveIdFromString(id);
    _log.d('ID $id assigned to item');
    }

  /// Update the "modified" date after a property was updated
  void update(){
    if(item != null){itemId = item.id;}
    modified = DateTime.now();

    /// Sanity checks for dates
    /// All rentals last at least for minimumRentalPeriod
    if(fetchedOn.isAfter(endDate)){
      endDate = fetchedOn.add(minimumRentalPeriod);
    }
    if(startDate.isAfter(endDate)){
      endDate = startDate.add(minimumRentalPeriod);
    }
    if(returnedOn.isBefore(fetchedOn)){
      fetchedOn = returnedOn.add(-minimumRentalPeriod);
    }
  }
}
