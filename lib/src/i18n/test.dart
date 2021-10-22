import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:libcli/delta/delta.dart' as delta;

class MockWaitView extends StatelessWidget {
  static int count = 0;

  const MockWaitView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}

class MockErrorView extends StatelessWidget {
  static int count = 0;

  const MockErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}

class MockOkView extends StatelessWidget {
  static int count = 0;

  const MockOkView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    count++;
    return const Text('');
  }
}

class MockProvider extends delta.AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 1), () {});
  }
}
