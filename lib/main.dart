import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/bloc_supervisor.dart';
import 'src/users/users.dart';
import 'ui/home_screen.dart';
import 'ui/login_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /// Interface to the firebase auth service
  final firebaseAuthInterface = FirebaseAuthInterface(FirebaseAuth.instance);

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(firebaseAuthInterface)
        ..add(AppStarted()),
      child: App(firebaseAuthInterface),
    ),
  );
}

/// Main Class for the apps state
class App extends StatelessWidget {
  /// Interface to the firebase auth service
  final FirebaseAuthInterface firebaseAuthInterface;

  /// Constructor for the app class
  App(this.firebaseAuthInterface);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return HomeScreen(state.user);
          }
          else {
            return LoginSplashScreen();
          }
        },
      ),
    );
  }
}