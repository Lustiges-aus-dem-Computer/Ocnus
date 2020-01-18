import 'package:flutter/material.dart';
import 'package:ocnus/services/localization.dart';
import 'package:hive/hive.dart';
import 'package:ocnus/business_logic/category.dart';

void main() async {
  Hive.registerAdapter(CategoryAdapter());
  runApp(Oknos());
  }

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