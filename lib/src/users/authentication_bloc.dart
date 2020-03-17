import 'dart:async';
import 'package:bloc/bloc.dart';
import 'authentication_events.dart';
import 'authentication_states.dart';
import 'firebase_auth_interface.dart';

/// This class contains all the business logic related
/// related to authentication workflows
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  /// User Account used in the wor
  FirebaseAuthInterface firebaseAuthInterface;

  /// Constructor for the authentication bloc
  AuthenticationBloc(this.firebaseAuthInterface);

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event,
      ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    }
    else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    }
    else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
    else if (event is PasswordReset) {
      yield* _mapResetPasswordToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await firebaseAuthInterface.isSignedIn();
      if (isSignedIn) {
        yield Authenticated(await firebaseAuthInterface.getUser());
      } else {
        yield Unauthenticated();
      }
    }
    on Exception catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await firebaseAuthInterface.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    firebaseAuthInterface.signOut();
  }

  Stream<AuthenticationState> _mapResetPasswordToState() async* {
    yield Authenticated(await firebaseAuthInterface.getUser());
    firebaseAuthInterface.resetPassword();
  }
}
