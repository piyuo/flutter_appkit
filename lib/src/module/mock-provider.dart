import 'dart:async';
import 'package:libcli/module.dart';
import 'package:flutter/material.dart';

class MockProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
