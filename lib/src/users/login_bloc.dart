import 'dart:async';
import 'package:bloc/bloc.dart';
import '../extension_funtions.dart';
import 'firebase_auth_interface.dart';
import 'login_events.dart';
import 'login_state.dart';

/// This class contains all the business logic related
/// related to the user login workflow
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  /// Interface to the Firebase auth service
  FirebaseAuthInterface firebaseAuthInterface;

  /// Constructor for login business logic component
  LoginBloc(this.firebaseAuthInterface);

  @override
  LoginState get initialState => LoginState();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is LoginPressed) {
      yield* _mapLoginPressedToState(
        email: event.email,
        password: event.password,
      );
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield LoginState(isEmailValid: email.isValidEmail());
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield LoginState(isPasswordValid: password.isValidPassword());
  }

  Stream<LoginState> _mapLoginPressedToState({
    String email,
    String password,
  }) async* {
    yield LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSubmitting: true);
    try {
      await firebaseAuthInterface.signInWithCredentials(email:email,
          password:password);
      yield LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isSuccess: true,);
    } on Exception catch (_) {
      yield LoginState(
        isEmailValid: true,
        isPasswordValid: true,
        isFailure: true,
      );
    }
  }
}
