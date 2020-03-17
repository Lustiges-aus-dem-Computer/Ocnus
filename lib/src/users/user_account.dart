import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_account.freezed.dart';

/// Role of the user
enum Role {
  /// User role not yet set
  unknown,
  /// Store clerc
  clerc,
}

@freezed
/// This class handles user accounts. It can later be extended to
/// include more information.
abstract class UserAccount with _$UserAccount {
  /// Create a minimal user account with only email and password
  factory UserAccount({@required String name, @required String email,
    @Default(Role.unknown) Role role}) = _UserAccount;
}