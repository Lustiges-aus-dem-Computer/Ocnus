import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rentables.dart';
export 'states.dart';

/// Bloc element (https://bloclibrary.dev/#/) for handling categories
class ReservationBlock extends Bloc<ReservationsEvent, ReservationsState>{
  /// Repository managing the database interactions for reservations
  final Repository repository;

  /// Constructor for the reservation bloc element
  ReservationBlock({@required this.repository});

  /// Initially, categories are still being loaded
  @override
  ReservationsState get initialState => ReservationsLoading();

  @override
  Stream<ReservationsState> mapEventToState(ReservationsEvent event) async*{
    /// Cannot use switch due to type mismatch
    if(event is LoadReservations){
      yield* _mapLoadReservationsToState(item: event.item);
    }
    else if(event is AddReservation){
      yield* _mapAddReservationToState(event.reservation);
    }
    else if(event is UpdateReservation){
      yield* _mapUpdateReservationToState(event.reservation);
    }
    else if(event is DeleteReservation){
      yield* _mapDeleteReservationToState(event.reservation);
    }
  }

  Stream<ReservationsState> _mapLoadReservationsToState(
    {Item item, bool remote}) async* {
    try {
      var reservations = 
      await repository.loadReservations(item.id);
      reservations ??= <Reservation>[];
      yield ReservationsLoaded(reservations);
    }
    /// In case we have no valid cage / server
    on Exception catch (_) {
      yield ReservationsNotLoaded();
    }
  }

  Stream<ReservationsState> _mapAddReservationToState(
    Reservation _reservation) async* {
    if (state is ReservationsLoaded) {
      /// Check if the update is valid
      var _validUpdate = await repository
        .checkValidUpdate([_reservation]);
      if(_validUpdate[0]){
        /// Cascade notation
        /// List.from is needed to create a new object
        /// and not alter the state
        final _newReservations = 
        List<Reservation>.from((state as ReservationsLoaded).reservationsList)
        ..add(_reservation);
        try {
          await repository
              .saveReservations([_reservation]);
          yield ReservationsLoaded(_newReservations);
        }
        on Exception catch (_) {
          yield ReservationsUpdateFailed();
        }
      }
      else{yield ReservationsInvalid();}
    }
  }

  Stream<ReservationsState> _mapUpdateReservationToState(
    Reservation _reservation) async* {
    if (state is ReservationsLoaded) {
      /// Check if the update is valid
      var _validUpdate = await repository
        .checkValidUpdate([_reservation]);

      if(_validUpdate[0]){
        /// Cascade notation
        /// List.from is needed to create a new object
        /// and not alter the state
        final _newReservations = List<Reservation>.from(
        (state as ReservationsLoaded).reservationsList.map((_resTmp) =>
        _resTmp.id == _reservation.id ? _reservation : _resTmp
        ));
        try {
          await repository
              .saveReservations([_reservation]);
          yield ReservationsLoaded(_newReservations);
        }
        on Exception catch (_) {
          yield ReservationsUpdateFailed();
        }
      }
      else{yield ReservationsInvalid();}
    }
  }

  Stream<ReservationsState> _mapDeleteReservationToState(
    Reservation _reservation) async* {
    if (state is ReservationsLoaded) {
      final _newReservations 
      = List<Reservation>.from(
        (state as ReservationsLoaded).reservationsList.where(
          (_resTmp) => _resTmp.id != _reservation.id
        ));
      try {
        /// Delete category from cage and server (if available)
        await repository.deleteReservations([_reservation.id]);
        yield ReservationsLoaded(_newReservations);
      }
      on Exception catch (_) {
        yield ReservationsUpdateFailed();
      }
    }
  }
}