import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oknos/services/local_id_generator.dart';
import 'dart:math';

void main() {
  Logger.level = Level.debug;
  test('Local Id Generator', () async {
    LocalIdGenerator _localIdGen = LocalIdGenerator(randomKeyIndex: 526177);
    expect(_localIdGen.getId(), 'ba01');
    _localIdGen = LocalIdGenerator(randomKeyIndex: 0);
    expect(_localIdGen.getId(), '0000');
    _localIdGen = LocalIdGenerator(randomKeyIndex: 1);
    expect(_localIdGen.getId(), '0001');
    _localIdGen = LocalIdGenerator(randomKeyIndex: pow(36, 4) - 1);
    expect(_localIdGen.getId(), 'zzzz');
    _localIdGen = LocalIdGenerator(randomKeyIndex: 119376);
    expect(_localIdGen.getId(), '2k40');
    _localIdGen = LocalIdGenerator(keyLength: 8, randomKeyIndex: pow(36, 8) - 2);
    expect(_localIdGen.getId(), 'zzzzzzzy');
  });
}