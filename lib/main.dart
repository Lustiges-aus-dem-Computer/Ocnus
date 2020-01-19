import 'package:flutter/material.dart';
import 'src/services/localization.dart';

void main() async {
  runApp(Oknos());
}

/// Main class of the app
class Oknos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [FlutterBlocLocalizationsDelegate()],
    );
  }
}
