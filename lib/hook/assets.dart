import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';

typedef Future<String> Get(fileName);
Get get;

/// mockInit Initializes the value for testing
///
///     I18nModel.mockInit('{"title": "mock"}');
///
@visibleForTesting
void mockInit(String result) {
  Future<String> mock(fileName) async {
    'assets_mock|get $NOUN$fileName$END return mock $NOUN2$result'.print;
    return result;
  }

  get = mock;
}
