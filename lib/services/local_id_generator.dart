//Generates temporary IDs in case the server cannot be reached
import 'dart:math';
import 'definitions.dart';
import 'logger.dart';

/// Generator for IDs meant for human consumption
class LocalIdGenerator {
  final _log = getLogger();

  /// Length of the IDs meant for human consumption
  int keyLength;

  /// Entropy of the id generated
  int entropy;
  static const String _base36 = '0123456789abcdefghijklmnopqrstuvwxyz';

  /// Index of the key in the list of possible keys
  int keyIndex;

  /// Generator for the human-readeable ID class
  LocalIdGenerator({this.keyLength = humanKeyLength, this.keyIndex}) {
    // Number of possible keys of length this.keyLength
    // using only digits and lower-case letters is
    // keyLength ^ 36
    entropy = keyLength ^ 36;
  }

  /// calculate the human-readeable ID
  String getId() {
    var rng = Random.secure();
    keyIndex ??= rng.nextInt(entropy);
    int powerOf36;
    var _id = '';
    for (var i = 0; i < keyLength; i++) {
      powerOf36 = pow(36, (keyLength - i - 1));
      _id += _base36[keyIndex ~/ powerOf36];
      keyIndex = keyIndex % powerOf36;
    }
    _log.d('Generated local id $_id');
    return _id;
  }

  /// Create unsigned integer from key for use in hive
  int getHiveId(String _id) {
    var _hiveId = 0;
    for (var i = 0; i < _id.length; i++) {
      _hiveId += pow(36, _id.length - i - 1) * _base36.indexOf(_id[i]);
    }
    return _hiveId;
  }
}
