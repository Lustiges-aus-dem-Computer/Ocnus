import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_events.freezed.dart';

/// Class managing events in the login workflow
class LoginEvent {
  /// Constructor for the abstract login events class
  LoginEvent();
}

@freezed
/// Class for managing email changes in the login workflow
abstract class EmailChanged extends LoginEvent with _$EmailChanged{
  /// Constructor for the email changed event
  factory EmailChanged({@required String email}) = _EmailChanged;
}

@freezed
/// Class for managing password changes in the login workflow
abstract class PasswordChanged extends LoginEvent with _$PasswordChanged{
  /// Constructor for the password changed event
  factory PasswordChanged({@required String password}) = _PasswordChanged;
}

@freezed
/// Class for informing the UI that the user has submitted the form
abstract class Submitted extends LoginEvent with _$Submitted {
  /// Constructor for the form-was-submitted event
  factory Submitted({
    @required String email,
    @required String password,
  }) = _Submitted;
}

@freezed
/// Class for informing the UI that the user has requested a password reset
abstract class PasswordResetPressed extends
LoginEvent with _$PasswordResetPressed {
  /// Constructor for the password reset event
  factory PasswordResetPressed({@required String email})
  = _PasswordResetPressed;
}

@freezed
/// Class for managing submission of a login workflow
abstract class LoginPressed extends LoginEvent with _$LoginPressed{
  /// Constructor for submission workflow
  factory LoginPressed({
    @required String email,
    @required String password,
  }) = _LoginPressed;
}
