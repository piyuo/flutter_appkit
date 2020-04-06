import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/pattern/async_provider.dart';

class MockProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
