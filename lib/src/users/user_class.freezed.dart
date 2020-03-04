// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'user_class.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$User {
  String get email;
  String get password;
  bool get active;

  User copyWith({String email, String password, bool active});
}

class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {@required String email, @required String password, bool active = true}) {
    return _User(
      email: email,
      password: password,
      active: active,
    );
  }
}

const $User = _$UserTearOff();

class _$_User with DiagnosticableTreeMixin implements _User {
  _$_User({@required this.email, @required this.password, this.active = true})
      : assert(email != null),
        assert(password != null);

  @override
  final String email;
  @override
  final String password;
  @JsonKey(defaultValue: true)
  @override
  final bool active;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'User(email: $email, password: $password, active: $active)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'User'))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('password', password))
      ..add(DiagnosticsProperty('active', active));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality()
                    .equals(other.password, password)) &&
            (identical(other.active, active) ||
                const DeepCollectionEquality().equals(other.active, active)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(active);

  @override
  _$_User copyWith({
    Object email = freezed,
    Object password = freezed,
    Object active = freezed,
  }) {
    return _$_User(
      email: email == freezed ? this.email : email as String,
      password: password == freezed ? this.password : password as String,
      active: active == freezed ? this.active : active as bool,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {@required String email,
      @required String password,
      bool active}) = _$_User;

  @override
  String get email;
  @override
  String get password;
  @override
  bool get active;

  @override
  _User copyWith({String email, String password, bool active});
}
