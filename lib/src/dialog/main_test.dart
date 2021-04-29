import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  setUp(() async {});

  group('[dialog]', () {
    test('should init', () async {
      var builder = init();
      expect(builder, isNotNull);
    });
  });
}
