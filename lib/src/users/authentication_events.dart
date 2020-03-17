import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_events.freezed.dart';

/// Here we manage all possible events for an authentication workflow
class AuthenticationEvent {
  /// Constructor for the abstract authentication events class
  const AuthenticationEvent();
}

@freezed
/// Event to notify the bloc that it needs to check if
/// the user is currently authenticated or not
abstract class AppStarted extends AuthenticationEvent with _$AppStarted {
  /// Constructor for the app starting event
  factory AppStarted() = _AppStarted;
}

@freezed
/// Event to notify the bloc that the user has successfully logged in
abstract class LoggedIn extends AuthenticationEvent  with _$LoggedIn {
  /// Constructor for the logged in event
  factory LoggedIn() = _LoggedIn;
}

@freezed
/// Event to notify the bloc that the user has requested a password reset
abstract class PasswordReset extends AuthenticationEvent  with _$PasswordReset {
  /// Constructor for the logged in event
  factory PasswordReset() = _PasswordReset;
}

@freezed
/// Event to notify the bloc that the user has successfully logged out
abstract class LoggedOut extends AuthenticationEvent with _$LoggedOut {
  /// Constructor for the logged out event
  factory LoggedOut() = _LoggedOut;
}