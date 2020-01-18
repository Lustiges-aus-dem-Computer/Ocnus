//Generates temporary IDs in case the server cannot be reached
import 'dart:math';
import 'logger.dart';
import 'package:ocnus/services/definitions.dart';

class LocalIdGenerator{
  final log = getLogger();
  int keyLength;
  var rng;
  int entropy;
  static const String _base36 = '0123456789abcdefghijklmnopqrstuvwxyz';
  int keyIndex;

  LocalIdGenerator({this.keyLength = globalKeyLength, this.keyIndex}){
    rng = new Random();
    // Number of possible keys of length this.keyLength
    // using only digits and lower-case letters is
    // keyLength ^ 36
    entropy = keyLength^36;
  }

  String getId(){
    keyIndex ??= rng.nextInt(entropy);
    int powerOf36;
    String _id = '';
    for(int i=0; i<keyLength; i++){
      powerOf36 = pow(36,(keyLength - i - 1));
      _id += _base36[keyIndex ~/ powerOf36];
      keyIndex = keyIndex % powerOf36;
    }
    log.d('Generated local id $_id');
    return _id;
  }

  // Create unsigned integer from key for use in hive
  int getHiveId(String _id){
    int _hiveId = 0;
    for(int i=0; i<_id.length; i++){
      _hiveId += pow(36, _id.length - i - 1) * _base36.indexOf(_id[i]);
    }
    return _hiveId;
  }
}