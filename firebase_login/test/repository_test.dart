import 'package:firebase_login/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/mockito.dart';


void main() {
  Logger.level = Level.debug;
  final _mockGoogleSignIn = MockGoogleSignIn();
  final _mockFirebaseAuth = MockFirebaseAuth();
  when(_mockGoogleSignIn.signOut()).thenAnswer((_)
  => Future.value(MockGoogleSignInAccount()));
  when(_mockFirebaseAuth.signOut()).thenAnswer((_)
  => Future.value(MockGoogleSignInAccount()));
  final _userRepository = UserRepository(googleSignin: _mockGoogleSignIn,
  firebaseAuth: _mockFirebaseAuth);

  test('Sign in with Google', () async {
    expect(await _userRepository.signInWithGoogle(), isNotNull);
  });

  test('Sign in with Credentials', () async {
    _userRepository.signInWithCredentials(
        email: 'test@test.de', password: '1234');
  });

  test('Sign up', () async {
    await _userRepository.signUp(email: 'test@test.de', password: '1234');
  });

  test('Is signed in', () async {
    expect(await _userRepository.isSignedIn(), isNotNull);
  });

  test('Get user', () async {
    expect(await _userRepository.getUser(), isNull);
  });

  test('Sign out', () async {
    await _userRepository.signOut();
  });
}
