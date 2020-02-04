import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../rentables.dart';

/// We need to use immutable objects here
/// In 'category_bloc.dart' When we yield a state in the private 
/// mapEventToState handlers, we will always need to yield a new state 
/// instead of mutating the existing state. This is because every time 
/// we yield, bloc will compare the state to the nextState and will only 
/// trigger a state change (transition) if the two states are not equal.

/// Abstract class for possible category states
abstract class CategoriesState extends Equatable{
  /// Constructor is constant because this and inheriting
  /// classes need to be immutable
  const CategoriesState();
}

/// State for when categories are loading
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

/// State for when updating the categories has failed
class CategoriesUpdateFailed extends CategoriesState {
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
  /// List of reservations that have been loaded
  final List<Reservation> reservationsList;

  /// Constructor initializing an emply reservations list
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

/// State for when updating the reservations has failed
class ReservationsUpdateFailed extends ReservationsState {
  @override
  List<Object> get props => [];
}



/// Abstract class for possible items states
abstract class ItemsState extends Equatable{
  /// Constructor is constant because this and inheriting
  /// classes need to be immutable
  const ItemsState();
}

/// State for when items are loading
class ItemsLoading extends ItemsState {
  @override
  List<Object> get props => [];
}

/// State for when items have been loaded
class ItemsLoaded extends ItemsState {
  /// List of items that have been loaded
  final List<Item> itemList;

  /// Constructor initializing an emply items list
  const ItemsLoaded([this.itemList = const []]);

  @override
  List<Item> get props => itemList;
}

/// State for when item search strings have been loaded
class ItemsSearchParametersLoaded extends ItemsState {
  /// List of search strings that have been loaded
  final Map<String,Map<searchParameters, String>> itemSearchParameters;

  /// Constructor initializing an emply term list
  const ItemsSearchParametersLoaded([this.itemSearchParameters = const {}]);

  @override
  List<String> get props => List<String>.from(itemSearchParameters.keys);
}

/// State for when items have not been loaded
/// Will be used for both items and search strings alike
class ItemsNotLoaded extends ItemsState {
  @override
  List<Object> get props => [];
}

/// State for when updating the item has failed
class ItemsUpdateFailed extends ItemsState {
  @override
  List<Object> get props => [];
}