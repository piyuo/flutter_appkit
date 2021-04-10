import 'dart:async';
import 'package:libcli/src/module/async-provider.dart';
import 'package:flutter/widgets.dart';

class MockProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
