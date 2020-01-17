import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oknos/services/local_id_generator.dart';
import 'dart:math';

void main() {
  Logger.level = Level.debug;
  test('Local Id', () async {
    LocalIdGenerator _localIdGen = LocalIdGenerator(randomNumber: 526177);
    expect(_localIdGen.getId(), '10ab');
    _localIdGen = LocalIdGenerator(randomNumber: 0);
    expect(_localIdGen.getId(), '0000');
    _localIdGen = LocalIdGenerator(randomNumber: pow(36, 4) - 1);
    expect(_localIdGen.getId(), 'zzzz');
    _localIdGen = LocalIdGenerator(randomNumber: 119376);
    expect(_localIdGen.getId(), '04k2');
  });
}