import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'user_account.dart';

/// This implements interactions with firebase auth:
/// account creation
/// account deletion
/// login
/// sign-out
/// Account-confirmation for now is handled outside of the app
class FirebaseAuthInterface {
  /// Firebase authenticator used to interactions with firebase auth
  FirebaseAuth firebaseAuth;

  /// Initialize new user workflow class
  FirebaseAuthInterface(this.firebaseAuth);

  /// This is called "with credentials" to allow for easy future extensions
  Future<void> signInWithCredentials({@required String email,
    @required String password}) {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Method for signing up new users - account still need to be confirmed
  /// New parameters need to be added here
  Future<void> signUp({@required String email,
    @required String password, @required String name}) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Signs out the current user. New login methods need to be
  /// added here to make sure they are closed correctly
  Future<void> signOut() async {
    return Future.wait([firebaseAuth.signOut()]);
  }

  /// Check if the user is already signed out
  Future<bool> isSignedIn() async {
    final currentUser = await firebaseAuth.currentUser();
    return currentUser != null;
  }

  /// Sends a password reset email to the user
  Future<void> resetPassword() async {
    var _email = (await firebaseAuth.currentUser()).email;
    return firebaseAuth.sendPasswordResetEmail(email: _email);
  }

  /// Get the currently logged-in user
  Future<UserAccount> getUser() async {
    /// Get user account
    var _currentUser = await firebaseAuth.currentUser();
    return UserAccount(name: _currentUser.displayName,
        email: _currentUser.email);
  }
}