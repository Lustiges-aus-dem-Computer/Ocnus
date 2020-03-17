// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'authentication_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$Uninitialized {}

class _$UninitializedTearOff {
  const _$UninitializedTearOff();

  _Uninitialized call() {
    return _Uninitialized();
  }
}

const $Uninitialized = _$UninitializedTearOff();

class _$_Uninitialized implements _Uninitialized {
  _$_Uninitialized();

  @override
  String toString() {
    return 'Uninitialized()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Uninitialized);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _Uninitialized implements Uninitialized {
  factory _Uninitialized() = _$_Uninitialized;
}

mixin _$Authenticated {
  UserAccount get user;

  Authenticated copyWith({UserAccount user});
}

class _$AuthenticatedTearOff {
  const _$AuthenticatedTearOff();

  _Authenticated call(UserAccount user) {
    return _Authenticated(
      user,
    );
  }
}

const $Authenticated = _$AuthenticatedTearOff();

class _$_Authenticated implements _Authenticated {
  _$_Authenticated(this.user) : assert(user != null);

  @override
  final UserAccount user;

  @override
  String toString() {
    return 'Authenticated(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Authenticated &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(user);

  @override
  _$_Authenticated copyWith({
    Object user = freezed,
  }) {
    return _$_Authenticated(
      user == freezed ? this.user : user as UserAccount,
    );
  }
}

abstract class _Authenticated implements Authenticated {
  factory _Authenticated(UserAccount user) = _$_Authenticated;

  @override
  UserAccount get user;

  @override
  _Authenticated copyWith({UserAccount user});
}

mixin _$Unauthenticated {}

class _$UnauthenticatedTearOff {
  const _$UnauthenticatedTearOff();

  _Unauthenticated call() {
    return _Unauthenticated();
  }
}

const $Unauthenticated = _$UnauthenticatedTearOff();

class _$_Unauthenticated implements _Unauthenticated {
  _$_Unauthenticated();

  @override
  String toString() {
    return 'Unauthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Unauthenticated);
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

abstract class _Unauthenticated implements Unauthenticated {
  factory _Unauthenticated() = _$_Unauthenticated;
}
