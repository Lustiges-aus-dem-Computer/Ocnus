import '../entities/reservation.dart';

/// Funtion used to check the validity of a new reservation
bool checkReservationValidity({List<Reservation> existingReservations,
Reservation newReservation}){
  /// If there are not reservations that is fine
  if(existingReservations == null){return true;}
  for(var _itemRes in existingReservations){
    if(
      /// Check if new reservation starts during
      /// the validity period of an existing one
      (!newReservation.startDate.isBefore(_itemRes.startDate) &&
      !newReservation.startDate.isAfter(_itemRes.endDate)) ||
      /// Check if new reservation ends during
      /// the validity period of an existing one
      (!newReservation.endDate.isBefore(_itemRes.startDate) &&
      !newReservation.endDate.isAfter(_itemRes.endDate))
      )
      {return false;}
  }
  return true;
}