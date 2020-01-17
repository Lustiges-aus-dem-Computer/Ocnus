import 'dart:async';
import 'package:flutter/material.dart';
import 'logger.dart';

enum AppTexts {
  AppTitle
}

class FlutterBlocLocalizations {
  final log = getLogger();
  final Locale locale;
  FlutterBlocLocalizations(this.locale);

  static FlutterBlocLocalizations of(BuildContext context) {
    return Localizations.of<FlutterBlocLocalizations>(
      context,
      FlutterBlocLocalizations,
    );
  }

  static Map<String, Map<AppTexts, String>> _localizedValues = {
    'en': {
        AppTexts.AppTitle: 'Oknos',
      },
    'de': {
        AppTexts.AppTitle: 'Oknos',
      },
  };

  String get appTitle{
    log.d('Returning texts for language: ' + locale.languageCode);
    return _localizedValues[locale.languageCode][AppTexts.AppTitle];
    }
}

class FlutterBlocLocalizationsDelegate
    extends LocalizationsDelegate<FlutterBlocLocalizations> {
  @override
  Future<FlutterBlocLocalizations> load(Locale locale) =>
      Future(() => FlutterBlocLocalizations(locale));

  @override
  bool shouldReload(FlutterBlocLocalizationsDelegate old) => false;

  // We currently support both english and german
  @override
  bool isSupported(Locale locale){
    return locale.languageCode.toLowerCase().contains('de')
    || locale.languageCode.toLowerCase().contains('en');
  }
}