import 'package:equatable/equatable.dart';
import '../../rentables.dart';

/// We need to use immutable objects here
/// In 'category_bloc.dart' When we yield a state in the private 
/// mapEventToState handlers, we will always need to yield a new state 
/// instead of mutating the existing state. This is because every time 
/// we yield, bloc will compare the state to the nextState and will only 
/// trigger a state change (transition) if the two states are not equal.
/// Given this. we can use immutable objects here in the spirit of
/// functional programming. This also allows us to use Equatable which
/// is nice :-)

/// Abstract class for possible category states
abstract class CategoriesState extends Equatable{
  /// Constructor is constant because this and inheriting
  /// classes need to be immutable
  const CategoriesState();
}

/// State for when catefories are loading
class CategoriesLoading extends CategoriesState {
  @override
  List<Object> get props => [];
}

/// State for when categories have been loaded
class CategoriesLoaded extends CategoriesState {
  /// List of categories that have been loaded
  final List<Category> categoriesList;

  /// Constructor initializing an emply categories list
  const CategoriesLoaded([this.categoriesList = const []]);

  @override
  List<Category> get props => categoriesList;
}

/// State for when categories have not been loaded
class CategoriesNotLoaded extends CategoriesState {
  @override
  List<Object> get props => [];
}



/// Abstract class for possible reservation states
abstract class ReservationsState extends Equatable{
  /// Constructor is constant because this and inheriting
  /// classes need to be immutable
  const ReservationsState();
}

/// State for when reservations are loading
class ReservationsLoading extends ReservationsState {
  @override
  List<Object> get props => [];
}

/// State for when reservations have been loaded
class ReservationsLoaded extends ReservationsState {
  /// List of categories that have been loaded
  final List<Reservation> reservationsList;

  /// Constructor initializing an emply categories list
  const ReservationsLoaded([this.reservationsList = const []]);

  @override
  List<Reservation> get props => reservationsList;
}

/// State for when an invalid reservation was added
class ReservationsInvalid extends ReservationsState {
  @override
  List<Object> get props => [];
}

/// State for when reservations have not been loaded
class ReservationsNotLoaded extends ReservationsState {
  @override
  List<Object> get props => [];
}