import 'package:flutter/widgets.dart';

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
