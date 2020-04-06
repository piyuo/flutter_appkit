import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:flutter/foundation.dart';

typedef Future<String> Get(fileName);
Get get;

/// mockInit Initializes the value for testing
///
///     I18nModel.mockInit('{"title": "mock"}');
///
@visibleForTesting
void mock(String result) {
  Future<String> mock(fileName) async {
    debugPrint('assets_mock|get $NOUN$fileName$END return mock $NOUN2$result');
    return result;
  }

  get = mock;
}
