import 'package:flutter/material.dart';
import 'src/services/localization.dart';

void main() async {
  runApp(Ocnus());
}

/// Main class of the app
class Ocnus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [FlutterBlocLocalizationsDelegate()],
    );
  }
}
