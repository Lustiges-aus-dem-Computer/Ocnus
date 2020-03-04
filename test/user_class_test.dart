import 'package:logger/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ocnus/src/users/users.dart';

void main() {
  Logger.level = Level.debug;

  group('User', ()
  {
    test('Create new user', () async {
      var _user = User(email: 'karl.heinz@neuland.de', password: '123456');
      expect(_user.active, true);
      expect(_user.email, 'karl.heinz@neuland.de');
      expect(_user.password, '123456');
    });

    test('Make user inactive', () async {
      var _user = User(email: 'karl.heinz@neuland.de', password: '123456');
      expect(_user.active, true);
      _user = _user.copyWith(active: false);
      expect(_user.active, false);
    });
  });

}