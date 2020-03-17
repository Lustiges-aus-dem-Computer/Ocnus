// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$LoginState {
  bool get isEmailValid;
  bool get isPasswordValid;
  bool get isSubmitting;
  bool get isSuccess;
  bool get isFailure;

  LoginState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure});
}

class _$LoginStateTearOff {
  const _$LoginStateTearOff();

  _LoginState call(
      {bool isEmailValid = false,
      bool isPasswordValid = false,
      bool isSubmitting = false,
      bool isSuccess = false,
      bool isFailure = false}) {
    return _LoginState(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      isFailure: isFailure,
    );
  }
}

const $LoginState = _$LoginStateTearOff();

class _$_LoginState implements _LoginState {
  _$_LoginState(
      {this.isEmailValid = false,
      this.isPasswordValid = false,
      this.isSubmitting = false,
      this.isSuccess = false,
      this.isFailure = false});

  @JsonKey(defaultValue: false)
  @override
  final bool isEmailValid;
  @JsonKey(defaultValue: false)
  @override
  final bool isPasswordValid;
  @JsonKey(defaultValue: false)
  @override
  final bool isSubmitting;
  @JsonKey(defaultValue: false)
  @override
  final bool isSuccess;
  @JsonKey(defaultValue: false)
  @override
  final bool isFailure;

  @override
  String toString() {
    return 'LoginState(isEmailValid: $isEmailValid, isPasswordValid: $isPasswordValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, isFailure: $isFailure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LoginState &&
            (identical(other.isEmailValid, isEmailValid) ||
                const DeepCollectionEquality()
                    .equals(other.isEmailValid, isEmailValid)) &&
            (identical(other.isPasswordValid, isPasswordValid) ||
                const DeepCollectionEquality()
                    .equals(other.isPasswordValid, isPasswordValid)) &&
            (identical(other.isSubmitting, isSubmitting) ||
                const DeepCollectionEquality()
                    .equals(other.isSubmitting, isSubmitting)) &&
            (identical(other.isSuccess, isSuccess) ||
                const DeepCollectionEquality()
                    .equals(other.isSuccess, isSuccess)) &&
            (identical(other.isFailure, isFailure) ||
                const DeepCollectionEquality()
                    .equals(other.isFailure, isFailure)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isEmailValid) ^
      const DeepCollectionEquality().hash(isPasswordValid) ^
      const DeepCollectionEquality().hash(isSubmitting) ^
      const DeepCollectionEquality().hash(isSuccess) ^
      const DeepCollectionEquality().hash(isFailure);

  @override
  _$_LoginState copyWith({
    Object isEmailValid = freezed,
    Object isPasswordValid = freezed,
    Object isSubmitting = freezed,
    Object isSuccess = freezed,
    Object isFailure = freezed,
  }) {
    return _$_LoginState(
      isEmailValid:
          isEmailValid == freezed ? this.isEmailValid : isEmailValid as bool,
      isPasswordValid: isPasswordValid == freezed
          ? this.isPasswordValid
          : isPasswordValid as bool,
      isSubmitting:
          isSubmitting == freezed ? this.isSubmitting : isSubmitting as bool,
      isSuccess: isSuccess == freezed ? this.isSuccess : isSuccess as bool,
      isFailure: isFailure == freezed ? this.isFailure : isFailure as bool,
    );
  }
}

abstract class _LoginState implements LoginState {
  factory _LoginState(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure}) = _$_LoginState;

  @override
  bool get isEmailValid;
  @override
  bool get isPasswordValid;
  @override
  bool get isSubmitting;
  @override
  bool get isSuccess;
  @override
  bool get isFailure;

  @override
  _LoginState copyWith(
      {bool isEmailValid,
      bool isPasswordValid,
      bool isSubmitting,
      bool isSuccess,
      bool isFailure});
}
