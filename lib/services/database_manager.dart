import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../business_logic/category.dart';
import '../business_logic/reservation.dart';

/// Abstract class for all database interfaces (managers)
abstract class DatabaseManager {
  /// Function to initialize the manager
  Future<void> initialize();

  /// Function to dismiss the manager
  Future<void> dismiss();

  /// Function to request loading categories from the database
  Future<List<Category>> getCategories();

  /// Function to request saving categories to the database
  Future<void> putCategories(List<Category> _categoryList);

  /// Function to request loading categories from the database
  Future<List<Reservation>> getReservations();

  /// Function to request saving categories to the database
  Future<void> putReservations(List<Reservation> _reservationList);
}

/// Database interface (manager) for the Hive database
/// https://docs.hivedb.dev/#/
class HiveManager implements DatabaseManager {
  /// Hive box for saving categories -> non-lazy because there
  /// is little data and all of it can be kept in memory
  Box<Category> categoryCageBox;
  /// Hive box for saving reservations -> non-lazy because there
  /// is little data and all of it can be kept in memory
  Box<Reservation> reservationCageBox;

  /// Initialize the hive box
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    categoryCageBox = await Hive.openBox<Category>('categoryCageBox');
    reservationCageBox = await Hive.openBox<Reservation>('reservationCageBox');
  }

  @override
  Future<void> dismiss() async {
    categoryCageBox.close();
  }

  @override
  Future<List<Category>> getCategories() async {
    var _categoryList = <Category>[];
    for (int _id in categoryCageBox.keys.toList()) {
      _categoryList.add(categoryCageBox.get(_id));
    }
    return _categoryList;
  }

  @override
  Future<void> putCategories(List<Category> _categoryList) async {
    categoryCageBox.addAll(_categoryList);
    return;
  }

  @override
  Future<List<Reservation>> getReservations() async {
    var _reservationList = <Reservation>[];
    for (int _id in reservationCageBox.keys.toList()) {
      _reservationList.add(reservationCageBox.get(_id));
    }
    return _reservationList;
  }

  @override
  Future<void> putReservations(List<Reservation> _reservationList) async {
    reservationCageBox.addAll(_reservationList);
    return;
  }
}
