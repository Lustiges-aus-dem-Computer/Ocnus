import '../entities/reservation.dart';

/// Function used to check the validity of a new reservation
bool checkReservationValidity({List<Reservation> existingReservations,
Reservation newReservation}){
  /// If there are not reservations that is fine
  if(existingReservations == null){return true;}
  for(var _itemRes in existingReservations){
    /// Don't check a reservation against itself
    if(newReservation.id != _itemRes.id) {
      if (
        /// Check if the two data ranges overlap
        !(newReservation.startDate.isAfter(_itemRes.endDate)) ||
          !(newReservation.endDate.isBefore(_itemRes.startDate))
      ) {
        return false;
      }
    }
  }
  return true;
}