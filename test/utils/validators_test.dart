import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/utils/validators.dart';

void main() {
  setUp(() async {});

  group('[validators]', () {
    test('should validate email', () async {
      String error = emailValidator(null, '1');
      expect(error, isNotNull);
      error = emailValidator(null, 'johndoe@domain.com');
      expect(error, isNull);
    });

    test('should validate domain name', () async {
      String error = domainNameValidator(null, 'a');
      expect(error, isNotNull);
      error = domainNameValidator(null, 'www.gmail.com');
      expect(error, isNull);
    });
  });
}
