import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libcli/redux.dart';

class MockProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
