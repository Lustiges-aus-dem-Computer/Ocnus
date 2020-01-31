import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/definitions.dart';
import '../services/logger.dart';

part 'reservation.g.dart';

/// Class handling reservations of rentable items
@HiveType(typeId: 1)
class Reservation extends Equatable{
  /// ID of the reservation
  @HiveField(0)
  final String id;
  /// Name of the employee who created the reservation
  @HiveField(1)
  final String employee;
  /// Name of the customer requesting the reservation
  @HiveField(2)
  final String customerName;
  /// Phone number of the customer requesting the reservation
  @HiveField(3)
  final String customerPhone;
  /// Email address of the customer requesting the reservation
  @HiveField(4)
  final String customerMail;

  /// ID of the item - used for saving to Hive
  @HiveField(5)
  final String itemId;

  /// Start date of the reservation
  @HiveField(6)
  final DateTime startDate;
  /// End date of the reservation
  @HiveField(7)
  final DateTime endDate;
  /// Date the reserved item was picked up
  @HiveField(8)
  final DateTime fetchedOn;
  /// Date the reserved item was returned
  @HiveField(9)
  final DateTime returnedOn;

  /// Creation date of the instance
  @HiveField(10)
  final DateTime created;
  /// Date the instance was last modified
  @HiveField(11)
  final DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling reservations of rentable items
  Reservation(
    {
    @required this.employee,
    @required this.customerName,
    @required this.customerPhone,
    @required this.customerMail,
    @required this.startDate,
    @required this.endDate,
    @required this.itemId,
    @required this.created,
    @required this.modified,
    @required this.id,
    this.fetchedOn,
    this.returnedOn,
  })
    {
    _log.d('Reservation $id created');
    }

  /// Create a copy of a reservation and take in changing parameters
  Reservation copyWith(
    {
      String employee,
      String customerName,
      String customerPhone,
      String customerMail,
      DateTime startDate,
      DateTime endDate,
      DateTime fetchedOn,
      DateTime returnedOn,
    }){

    employee ??= this.employee;
    customerName ??= this.customerName;
    customerPhone ??= this.customerPhone;
    customerMail ??= this.customerMail;
    startDate ??= this.startDate;
    endDate ??= this.endDate;
    fetchedOn ??= this.fetchedOn;
    returnedOn ??= this.returnedOn;

    /// Sanity checks for dates
    /// All rentals last at least for minimumRentalPeriod
    if(fetchedOn != null){
      if(fetchedOn.isAfter(endDate)){
        endDate = fetchedOn.add(minimumRentalPeriod);
      }
    }
    if(startDate.isAfter(endDate)){
      endDate = startDate.add(minimumRentalPeriod);
    }
    if(returnedOn != null){
      if(returnedOn.isBefore(fetchedOn)){
        fetchedOn = returnedOn.add(-minimumRentalPeriod);
      }
    }

    return Reservation(
      employee: employee,
      customerName: customerName,
      customerPhone: customerPhone,
      customerMail: customerMail,
      startDate: startDate,
      endDate: endDate,
      itemId: itemId,
      fetchedOn: fetchedOn,
      returnedOn: returnedOn,
      created: created,
      modified: DateTime.now(),
      id: id
      );
  }

  @override
  List<Object> get props => [employee, customerName, customerPhone,
  customerMail, startDate, endDate, itemId,  created,
    modified, id, fetchedOn, returnedOn];
}
