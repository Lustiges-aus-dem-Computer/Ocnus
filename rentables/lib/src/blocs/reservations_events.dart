import 'package:flutter/cupertino.dart';

import '../entities/item.dart';
import '../entities/reservation.dart';

/// Abstract class for events to be handled by the reservation bloc
abstract class ReservationsEvent {}

/// Event triggering loading of reservations from the remote database
class LoadReservationsFromServer extends ReservationsEvent {
  /// Item for which the reservation should be loaded
  final Item item;

  /// Constructor for load reservation event
  LoadReservationsFromServer(this.item);
}

/// Event triggering loading of reservations
class LoadReservationsFromCage extends ReservationsEvent {
  /// Item for which the reservation should be loaded
  final Item item;

  /// Constructor for load reservation event
  LoadReservationsFromCage(this.item);
}

/// Evend triggering addition of a new reservation
/// This should only be allowed in offline mode for the store-app
/// A verification for that should be added later
class AddReservation extends ReservationsEvent {
  /// Category to be added
  final Reservation reservation;

  /// Constructor for new reservation event
  AddReservation(this.reservation);
}

/// Evend triggering updating of a reservation
class UpdateReservation extends ReservationsEvent {
  /// Reservation to be updated
  final Reservation reservation;
  /// Used to make updates work in testing
  final bool testing;

  /// Constructor for update reservation event
  UpdateReservation(this.reservation, {this.testing = false});
}

/// Evend triggering deletion of a reservation
class DeleteReservation extends ReservationsEvent {
  /// Reservation to be updated
  final Reservation reservation;

  /// Constructor for delete reservations event
  DeleteReservation(this.reservation);
}
