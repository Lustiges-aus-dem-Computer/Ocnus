import 'package:bloc_test/bloc_test.dart';
import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocnus/src/users/users.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuthInterface extends Mock implements FirebaseAuthInterface {}

void main() {
  Logger.level = Level.debug;

  const name = 'Karl-Heinz';
  const mail = 'karl-heinz@neuland.de';
  const password = 'jlks89ZlkjhdZLId';
  final user = UserAccount(name: name, email: mail);

  final fireAuthLoggedIn =  MockFirebaseAuthInterface();
  final fireAuthLoggedOut =  MockFirebaseAuthInterface();

  when(fireAuthLoggedIn.isSignedIn())
      .thenAnswer((_) => Future.value(true));
  when(fireAuthLoggedOut.isSignedIn())
      .thenAnswer((_) => Future.value(false));

  when(fireAuthLoggedIn.getUser())
      .thenAnswer((_) => Future.value(user));
  when(fireAuthLoggedOut.getUser())
      .thenAnswer((_) => Future.value(null));

  when(fireAuthLoggedIn.signInWithCredentials(email: mail,
      password:password)).thenAnswer((_) => null);

  group('Authentication states', ()
  {
    test('Authentication state', () async {
      expect(AuthenticationState(), isNotNull);
    });

    test('Uninitialized state', () async {
      expect(Uninitialized(), isNotNull);
    });

    test('Authenticated state', () async {
      expect(Authenticated(user), isNotNull);
    });

    test('Unauthenticated state', () async {
      expect(Unauthenticated(), isNotNull);
    });
  });

  group('Authentication events', ()
  {
    test('Authentication event', () async {
      expect(AuthenticationEvent(), isNotNull);
    });

    test('PasswordReset event', () async {
      expect(PasswordReset(), isNotNull);
    });

    test('AppStarted event', () async {
      expect(AppStarted(), isNotNull);
    });

    test('LoggedIn event', () async {
      expect(LoggedIn(), isNotNull);
    });

    test('LoggedOut event', () async {
      expect(LoggedOut(), isNotNull);
    });
  });

  group('Authentication bloc', ()
  {
    blocTest(
      'Start app as logged in user',
      build: () async => AuthenticationBloc(fireAuthLoggedIn),
      act: (bloc) => bloc.add(AppStarted()),
      expect: [Authenticated(user)],
    );
    blocTest(
      'Start app as unknown user',
      build: () async => AuthenticationBloc(fireAuthLoggedOut),
      act: (bloc) => bloc.add(AppStarted()),
      expect: [Unauthenticated()],
    );
    blocTest(
      'Reset password',
      build: () async => AuthenticationBloc(fireAuthLoggedIn),
      act: (bloc) => bloc.add(PasswordReset()),
      expect: [Authenticated(user)],
    );
    blocTest(
      'Log out',
      build: () async => AuthenticationBloc(fireAuthLoggedIn),
      act: (bloc) => bloc.add(LoggedOut()),
      expect: [Unauthenticated()],
    );
  });

  group('Login events', ()
  {
    test('Email changed event', () async {
      expect(EmailChanged(email:mail), isNotNull);
    });

    test('Password changed event', () async {
      expect(PasswordChanged(password: password), isNotNull);
    });

    test('Submitted event', () async {
      expect(Submitted(email: mail, password: password), isNotNull);
    });

    test('Password reset event', () async {
      expect(PasswordResetPressed(email: mail), isNotNull);
    });

    test('Login pressed event', () async {
      expect(LoginPressed(email: mail, password: password), isNotNull);
    });
  });

  group('Login states', ()
  {
    test('Set login state', () async {
      var _state = LoginState();
      expect(_state.isEmailValid, false);
      expect(_state.isPasswordValid, false);
      expect(_state.isSubmitting, false);
      expect(_state.isSuccess, false);
      expect(_state.isFailure, false);
    });

    test('Set properties', () async {
      var _state = LoginState(isEmailValid: true, isPasswordValid: true,
          isSubmitting: true, isSuccess: true, isFailure: true);
      expect(_state.isEmailValid, true);
      expect(_state.isPasswordValid, true);
      expect(_state.isSubmitting, true);
      expect(_state.isSuccess, true);
      expect(_state.isFailure, true);
    });
  });

  group('Login bloc', ()
  {
    blocTest(
      'Email changed',
      build: () async => LoginBloc(fireAuthLoggedIn),
      act: (bloc) => bloc.add(EmailChanged(email: mail)),
      expect: [LoginState(isEmailValid:true)],
    );
    blocTest(
      'Password changed',
      build: () async => LoginBloc(fireAuthLoggedIn),
      act: (bloc) => bloc.add(PasswordChanged(password: password)),
      expect: [LoginState(isPasswordValid:true)],
    );
    blocTest(
      'User logging in',
      build: () async => LoginBloc(fireAuthLoggedIn),
      act: (bloc) => bloc.add(LoginPressed(email: mail, password: password)),
      expect: [
        LoginState(
          isEmailValid: true,
          isPasswordValid: true,
          isSubmitting: true),
        LoginState(
          isEmailValid: true,
          isPasswordValid: true,
          isSuccess: true)],
    );
  });
}