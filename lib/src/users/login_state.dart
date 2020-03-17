import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
/// Class maneging the states of the login workflow
abstract class LoginState with _$LoginState {

  /// Construct a now login state -> all properties defaulted to "false"
  factory LoginState({
    /// Is the email address valid?
    @Default(false) bool isEmailValid,
    /// Is the password valid?
    @Default(false) bool isPasswordValid,
    /// Has the request been submitted?
    @Default(false) bool isSubmitting,
    /// Was the login successful?
    @Default(false) bool isSuccess,
    /// Did the login fail?
    @Default(false) bool isFailure,
  }) = _LoginState;

}
