import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rentables.dart';
export 'states.dart';

/// Bloc element (https://bloclibrary.dev/#/) for handling categories
class ReservationBlock extends Bloc<ReservationsEvent, ReservationsState>{
  /// Repository managing the database interactions for reservations
  final ReservationRepository reservationRepository;

  /// Constructor for the reservation bloc element
  ReservationBlock({@required this.reservationRepository});

  /// Initially, categories are still being loaded
  @override
  ReservationsState get initialState => ReservationsLoading();

  @override
  Stream<ReservationsState> mapEventToState(ReservationsEvent event) async*{
    /// Cannot use switch due to type mismatch
    if(event is LoadReservationsFromCage){
      yield* _mapLoadReservationsToState(item: event.item, remote: false);
    }
    else if(event is LoadReservationsFromServer){
      yield* _mapLoadReservationsToState(item: event.item, remote: true);
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
      final reservations = 
      await reservationRepository.loadReservations(item, remote: remote);
      yield ReservationsLoaded(reservations);
    }
    /// In case we have no valid cage
    on Exception catch (_) {
      yield ReservationsNotLoaded();
    }
  }

  Stream<ReservationsState> _mapAddReservationToState(
    Reservation _reservation) async* {
    if (state is ReservationsLoaded) {
      /// Check if the update is valid
      var _validUpdate = await reservationRepository
        .checkValidUpdate(reservationList: [_reservation]);
      if(_validUpdate){
        /// Cascade notation
        /// List.from is needed to create a new object
        /// and not alter the state
        final _newReservations = 
        List<Reservation>.from((state as ReservationsLoaded).reservationsList)
        ..add(_reservation);
        yield ReservationsLoaded(_newReservations);
        reservationRepository
        .saveReservations([_reservation], forceValid: true);
      }
      else{yield ReservationsInvalid();}
    }
  }

  Stream<ReservationsState> _mapUpdateReservationToState(
    Reservation _reservation) async* {
    if (state is ReservationsLoaded) {
      /// Check if the update is valid
      var _validUpdate = await reservationRepository
        .checkValidUpdate(reservationList: [_reservation]);
      if(_validUpdate){
        /// Cascade notation
        /// List.from is needed to create a new object
        /// and not alter the state
        final _newReservations = List<Reservation>.from(
        (state as ReservationsLoaded).reservationsList.map((_resTmp) =>
        _resTmp.id == _reservation.id ? _reservation : _resTmp
        ));
        yield ReservationsLoaded(_newReservations);
        reservationRepository
        .saveReservations([_reservation], forceValid: true);
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
      yield ReservationsLoaded(_newReservations);
      /// Delete category from cage and server (if available)
      reservationRepository.deleteReservations([_reservation.id]);
    }
  }
}