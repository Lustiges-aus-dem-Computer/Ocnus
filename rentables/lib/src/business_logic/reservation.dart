import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../services/logger.dart';

part 'reservation.g.dart';

/// Class handling reservations of rentable items
@HiveType(typeId: 1)
class Reservation {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _employee;
  @HiveField(2)
  String _customerName;
  @HiveField(3)
  String _customerPhone;
  @HiveField(4)
  String _customerMail;

  @HiveField(5)
  DateTime _startDate;
  @HiveField(6)
  DateTime _endDate;
  @HiveField(7)
  DateTime _fetchedOn;
  @HiveField(8)
  DateTime _returnedOn;

  /// Creation date of the instance
  @HiveField(9)
  DateTime created;
  /// Date the instance was last modified
  @HiveField(10)
  DateTime modified;

  final _log = getLogger();

  /// Constructor for class handling reservations of rentable items
  Reservation({
    @required String employee,
    @required String customerName,
    @required String customerPhone,
    @required String customerMail,
    @required DateTime startDate,
    @required DateTime endDate,
    DateTime fetchedOn,
    DateTime returnedOn,
    String id,
    DateTime created,
    DateTime modified,
  })  : _employee = employee,
        _customerName = customerName,
        _customerPhone = customerPhone,
        _customerMail = customerMail,
        _startDate = startDate,
        _endDate = endDate,
        _returnedOn = returnedOn,
        _fetchedOn = fetchedOn,
        _id = id ??
            Uuid().v4(),
        created = DateTime.now(),
        modified = DateTime.now() {
    _log.d('UUID $this.id assigned to category');
    }

  /// Name of the employee that registred the reservation
  String get employee => _employee;

  /// Name of the customer
  String get customerName => _customerName;

  /// UUID of the reservation
  String get id => _id;

  /// Phone number of the customer
  String get customerPhone => _customerPhone;

  /// E-mail address of the customer
  String get customerMail => _customerMail;

  /// Start-date of the reservation
  DateTime get startDate => _startDate;

  /// End-date of the reservation
  DateTime get endDate => _endDate;

  /// Date the reserved item was retrieved
  DateTime get fetchedOn => _fetchedOn;

  /// Date the reserved item was returned
  DateTime get returnedOn => _returnedOn;

  /// Update the "modified" date after a property was updated
  void update() => modified = DateTime.now();

  /// All setters need to update the modified propterty

  /// Setter for the employee name updating the modified date
  set employee(String valIn) {
    _employee = valIn;
    update();
  }

  /// Setter for the customer name updating the modified date
  set customerName(String valIn) {
    _customerName = valIn;
    update();
  }

  /// Setter for the customer phone number updating the modified date
  set customerPhone(String valIn) {
    _customerPhone = valIn;
    update();
  }

  /// Setter for the customer email address updating the modified date
  set customerMail(String valIn) {
    _customerMail = valIn;
    update();
  }

  /// Setter for id created explicitely so modified date is updated
  set id(String valIn) {
    _id = valIn;
    update();
  }

  /// Setter for the reservation start date updating the modified date
  set startDate(DateTime valIn) {
    if(valIn.isAfter(_startDate)){
      _log.w('A reservations end date cannot be after it\'s start date');
      _log.w('End date was automatically shifted to the new start date');
      _endDate = valIn;
    }
    _startDate = valIn;
    update();
  }

  /// Setter for the reservation end date with validations
  set endDate(DateTime valIn) {
    if(valIn.isBefore(_startDate)){
      _log.w('A reservations end date cannot be before it\'s start date');
      _log.w('Start date was automatically shifted to the new end date');
      _startDate = valIn;
    }
    if(_fetchedOn != null && _fetchedOn.isAfter(valIn)){
      _log.w('A reservations fetched-on date cannot be after it\'s end date');
      _log.w('Fetched-on date automatically adjusted to new end date');
      _fetchedOn = valIn;
    }
    _endDate = valIn;
    update();
  }

  /// Setter for the date an item was returned
  set returnedOn(DateTime valIn) {
    if(valIn.isBefore(_startDate)){
      _log.w('A reservations return date cannot be before it\'s start date');
      _log.w('Start date was shifted to the new return date');
      _startDate = valIn;
    }
    if(valIn.isBefore(_fetchedOn)){
      _log.w('A reservations return date cannot be'
      'before it\'s fetched-on date');
      _log.w('Fetched-on date was shifted to the new return date');
      _fetchedOn = valIn;
    }
    _returnedOn = valIn;
    update();
  }

  /// Setter for the reservation fetched on updating the modified date
  set fetchedOn(DateTime valIn) {
    if(valIn.isAfter(_endDate)){
      _log.w('A reservations fetched-on date cannot be after it\'s end date');
      _log.w('End date was automatically shifted to the new fetched-on date');
      _endDate = valIn;
    }
    _fetchedOn = valIn;
    update();
  }
}
