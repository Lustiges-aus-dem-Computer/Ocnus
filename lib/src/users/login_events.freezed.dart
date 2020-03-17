// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'login_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$LoginEvent {}

class _$LoginEventTearOff {
  const _$LoginEventTearOff();

  _LoginEvent call() {
    return _LoginEvent();
  }
}

const $LoginEvent = _$LoginEventTearOff();

class _$_LoginEvent implements _LoginEvent {
  _$_LoginEvent();

  @override
  String toString() {
    return 'LoginEvent()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _LoginEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _LoginEvent implements LoginEvent {
  factory _LoginEvent() = _$_LoginEvent;
}

mixin _$EmailChanged {
  String get email;

  EmailChanged copyWith({String email});
}

class _$EmailChangedTearOff {
  const _$EmailChangedTearOff();

  _EmailChanged call({@required String email}) {
    return _EmailChanged(
      email: email,
    );
  }
}

const $EmailChanged = _$EmailChangedTearOff();

class _$_EmailChanged implements _EmailChanged {
  _$_EmailChanged({@required this.email}) : assert(email != null);

  @override
  final String email;

  @override
  String toString() {
    return 'EmailChanged(email: $email)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _EmailChanged &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(email);

  @override
  _$_EmailChanged copyWith({
    Object email = freezed,
  }) {
    return _$_EmailChanged(
      email: email == freezed ? this.email : email as String,
    );
  }
}

abstract class _EmailChanged implements EmailChanged {
  factory _EmailChanged({@required String email}) = _$_EmailChanged;

  @override
  String get email;

  @override
  _EmailChanged copyWith({String email});
}

mixin _$PasswordChanged {
  String get password;

  PasswordChanged copyWith({String password});
}

class _$PasswordChangedTearOff {
  const _$PasswordChangedTearOff();

  _PasswordChanged call({@required String password}) {
    return _PasswordChanged(
      password: password,
    );
  }
}

const $PasswordChanged = _$PasswordChangedTearOff();

class _$_PasswordChanged implements _PasswordChanged {
  _$_PasswordChanged({@required this.password}) : assert(password != null);

  @override
  final String password;

  @override
  String toString() {
    return 'PasswordChanged(password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PasswordChanged &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(password);

  @override
  _$_PasswordChanged copyWith({
    Object password = freezed,
  }) {
    return _$_PasswordChanged(
      password: password == freezed ? this.password : password as String,
    );
  }
}

abstract class _PasswordChanged implements PasswordChanged {
  factory _PasswordChanged({@required String password}) = _$_PasswordChanged;

  @override
  String get password;

  @override
  _PasswordChanged copyWith({String password});
}

mixin _$Submitted {
  String get email;
  String get password;

  Submitted copyWith({String email, String password});
}

class _$SubmittedTearOff {
  const _$SubmittedTearOff();

  _Submitted call({@required String email, @required String password}) {
    return _Submitted(
      email: email,
      password: password,
    );
  }
}

const $Submitted = _$SubmittedTearOff();

class _$_Submitted implements _Submitted {
  _$_Submitted({@required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'Submitted(email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Submitted &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password);

  @override
  _$_Submitted copyWith({
    Object email = freezed,
    Object password = freezed,
  }) {
    return _$_Submitted(
      email: email == freezed ? this.email : email as String,
      password: password == freezed ? this.password : password as String,
    );
  }
}

abstract class _Submitted implements Submitted {
  factory _Submitted({@required String email, @required String password}) =
      _$_Submitted;

  @override
  String get email;
  @override
  String get password;

  @override
  _Submitted copyWith({String email, String password});
}

mixin _$PasswordResetPressed {
  String get email;

  PasswordResetPressed copyWith({String email});
}

class _$PasswordResetPressedTearOff {
  const _$PasswordResetPressedTearOff();

  _PasswordResetPressed call({@required String email}) {
    return _PasswordResetPressed(
      email: email,
    );
  }
}

const $PasswordResetPressed = _$PasswordResetPressedTearOff();

class _$_PasswordResetPressed implements _PasswordResetPressed {
  _$_PasswordResetPressed({@required this.email}) : assert(email != null);

  @override
  final String email;

  @override
  String toString() {
    return 'PasswordResetPressed(email: $email)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PasswordResetPressed &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(email);

  @override
  _$_PasswordResetPressed copyWith({
    Object email = freezed,
  }) {
    return _$_PasswordResetPressed(
      email: email == freezed ? this.email : email as String,
    );
  }
}

abstract class _PasswordResetPressed implements PasswordResetPressed {
  factory _PasswordResetPressed({@required String email}) =
      _$_PasswordResetPressed;

  @override
  String get email;

  @override
  _PasswordResetPressed copyWith({String email});
}

mixin _$LoginPressed {
  String get email;
  String get password;

  LoginPressed copyWith({String email, String password});
}

class _$LoginPressedTearOff {
  const _$LoginPressedTearOff();

  _LoginPressed call({@required String email, @required String password}) {
    return _LoginPressed(
      email: email,
      password: password,
    );
  }
}

const $LoginPressed = _$LoginPressedTearOff();

class _$_LoginPressed implements _LoginPressed {
  _$_LoginPressed({@required this.email, @required this.password})
      : assert(email != null),
        assert(password != null);

  @override
  final String email;
  @override
  final String password;

  @override
  String toString() {
    return 'LoginPressed(email: $email, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LoginPressed &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password);

  @override
  _$_LoginPressed copyWith({
    Object email = freezed,
    Object password = freezed,
  }) {
    return _$_LoginPressed(
      email: email == freezed ? this.email : email as String,
      password: password == freezed ? this.password : password as String,
    );
  }
}

abstract class _LoginPressed implements LoginPressed {
  factory _LoginPressed({@required String email, @required String password}) =
      _$_LoginPressed;

  @override
  String get email;
  @override
  String get password;

  @override
  _LoginPressed copyWith({String email, String password});
}
