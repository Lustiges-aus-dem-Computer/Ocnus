import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'business_logic/category.dart';
import 'services/localization.dart';

void main() async {
  Hive.registerAdapter(CategoryAdapter());
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
