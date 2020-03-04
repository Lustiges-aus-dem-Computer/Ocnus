import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_class.freezed.dart';

@freezed
/// This class handles user accounts. It can later be extended to
/// include more information.
abstract class User with _$User {
  /// Create a minimal user account with only email and password
  factory User({@required String email, @required String password,
    @Default(true) bool active}) = _User;
}