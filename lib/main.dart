import 'package:flutter/material.dart';
import 'package:oknos/services/localization.dart';

void main() => runApp(Oknos());

class Oknos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        FlutterBlocLocalizationsDelegate()
        ],
    );
  }
}