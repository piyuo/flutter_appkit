import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:libcli/delta.dart' as delta;

class MockWaitView extends StatelessWidget {
  static int count = 0;
  @override
  Widget build(BuildContext context) {
    count++;
    return Text('');
  }
}

class MockErrorView extends StatelessWidget {
  static int count = 0;

  @override
  Widget build(BuildContext context) {
    count++;
    return Text('');
  }
}

class MockOkView extends StatelessWidget {
  static int count = 0;
  @override
  Widget build(BuildContext context) {
    count++;
    return Text('');
  }
}

class MockProvider extends delta.AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1), () {});
  }
}
