import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocnus/src/users/users.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockFirebaseUser extends Mock implements FirebaseUser {}


void main() {
  Logger.level = Level.debug;

  const mail = 'karl-heinz@neuland.de';
  const name = 'Karl-Heinz';
  const password = 'password1';
  var user = UserAccount(name: name, email: mail);
  var login = LoginState();

  final fireAuth = MockFirebaseAuth();
  final fireUser = MockFirebaseUser();

  when(fireUser.email).thenAnswer((_) => mail);
  when(fireUser.displayName).thenAnswer((_) => name);
  when(fireAuth.currentUser()).thenAnswer((_) => Future.value(fireUser));
  when(fireAuth.signOut()).thenAnswer((_) => Future.value());

  final userWorkflow = FirebaseAuthInterface(fireAuth);

  group('User account', ()
  {
    test('Create new user', () async {
      expect(user.role, Role.unknown);
      expect(user.name, name);
    });

    test('Confirmed', () async {
      expect(user.role, Role.unknown);
      user = user.copyWith(role: Role.clerc);
      expect(user.role, Role.clerc);
      user = user.copyWith(role: Role.unknown);
    });
  });

  group('Login state', ()
  {
    test('Create login state', () async {
      expect(login.isEmailValid, false);
    });

    test('Valid email', () async {
      expect(login.isEmailValid, false);
      login = login.copyWith(isEmailValid: true);
      expect(login.isEmailValid, true);
    });
  });

  group('User Workflows', ()
  {
    test('Sign in with credentials', () async {
      await userWorkflow.signInWithCredentials(email: mail,
          password: password);
    });

    test('Sign up a new user', () async {
      await userWorkflow.signUp(email: mail, name: name,
          password: password);
    });

    test('Sign out the user', () async {
      await userWorkflow.signOut();
    });

    test('Check if user is signed in', () async {
      expect(await userWorkflow.isSignedIn(), true);
    });

    test('Send password reset mail', () async {
      await userWorkflow.resetPassword();
    });

    test('Get currently signed-in user', () async {
      expect(await userWorkflow.getUser(), user);
    });
  });

}