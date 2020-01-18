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
  int randomKeyIndex;

  LocalIdGenerator({this.keyLength = 4, this.randomKeyIndex}){
    rng = new Random();
    // Number of possible keys of length this.keyLength
    // using only digits and lower-case letters is
    // keyLength ^ 36
    entropy = keyLength^36;
  }

  String getId(){
    randomKeyIndex ??= rng.nextInt(entropy);
    int powerOf36;
    String _id = '';
    for(int i=0; i<keyLength; i++){
      powerOf36 = pow(36,(keyLength - i - 1));
      _id += _base36[randomKeyIndex ~/ powerOf36];
      randomKeyIndex = randomKeyIndex % powerOf36;
    }
    log.d('Generated local id $_id');
    return _id;
  }
}