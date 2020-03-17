import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_account.dart';

part 'authentication_states.freezed.dart';

/// Here we handle the state of our login workflow
 class AuthenticationState {
  /// Constructor for the abstract authentication state class
  const AuthenticationState();
}

@freezed
/// State for when the login process has not yet been initialized
abstract class Uninitialized
    extends AuthenticationState with _$Uninitialized {
  /// Constructor for the uninitialized login state
  factory Uninitialized() = _Uninitialized;
}

@freezed
/// State for when the user has been authenticated
abstract class Authenticated
    extends AuthenticationState with _$Authenticated{
  /// In the authenticated state a user account has been retrieved
  factory Authenticated(UserAccount user) = _Authenticated;
}

@freezed
/// State for when the user was not successfully authenticated
abstract class Unauthenticated
    extends AuthenticationState with _$Unauthenticated{
  /// Constructor for the unauthenticated login state
  factory Unauthenticated() = _Unauthenticated;
}