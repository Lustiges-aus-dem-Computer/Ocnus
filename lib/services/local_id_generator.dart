//Generates temporary IDs in case the server cannot be reached
import 'dart:math';
import 'logger.dart';
import 'package:flutter/material.dart';

class LocalIdGenerator{
  final log = getLogger();
  int keyLength;
  var rng;
  int entropy;
  static const String _base36 = '0123456789abcdefghijklmnopqrstuvwxyz';
  @visibleForTesting
  int randomNumber;

  LocalIdGenerator({this.keyLength = 4, this.randomNumber}){
    rng = new Random();
    // Number of possible keys of length this.keyLength
    // using only digits and lower-case letters is
    // keyLength ^ 36
    entropy = keyLength^36;
  }

  String getId(){
    int randInt  = randomNumber ?? rng.nextInt(entropy);
    int powerOf36;
    String _id = '';
    for(int i=0; i<keyLength; i++){
      powerOf36 = pow(36,(keyLength - i - 1));
      _id += _base36[randInt ~/ powerOf36];
      randInt = randInt % powerOf36;
    }
    _id = _id.split('').reversed.join();
    log.d('Generated local id $_id');
    return _id;
  }
}