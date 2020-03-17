// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'user_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$UserAccount {
  String get name;
  String get email;
  Role get role;

  UserAccount copyWith({String name, String email, Role role});
}

class _$UserAccountTearOff {
  const _$UserAccountTearOff();

  _UserAccount call(
      {@required String name,
      @required String email,
      Role role = Role.unknown}) {
    return _UserAccount(
      name: name,
      email: email,
      role: role,
    );
  }
}

const $UserAccount = _$UserAccountTearOff();

class _$_UserAccount with DiagnosticableTreeMixin implements _UserAccount {
  _$_UserAccount(
      {@required this.name, @required this.email, this.role = Role.unknown})
      : assert(name != null),
        assert(email != null);

  @override
  final String name;
  @override
  final String email;
  @JsonKey(defaultValue: Role.unknown)
  @override
  final Role role;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserAccount(name: $name, email: $email, role: $role)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserAccount'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('role', role));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UserAccount &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(role);

  @override
  _$_UserAccount copyWith({
    Object name = freezed,
    Object email = freezed,
    Object role = freezed,
  }) {
    return _$_UserAccount(
      name: name == freezed ? this.name : name as String,
      email: email == freezed ? this.email : email as String,
      role: role == freezed ? this.role : role as Role,
    );
  }
}

abstract class _UserAccount implements UserAccount {
  factory _UserAccount(
      {@required String name,
      @required String email,
      Role role}) = _$_UserAccount;

  @override
  String get name;
  @override
  String get email;
  @override
  Role get role;

  @override
  _UserAccount copyWith({String name, String email, Role role});
}
