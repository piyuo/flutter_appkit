import 'package:flutter/material.dart';
import 'hypertext/hypertext.dart';
import 'package:provider/provider.dart';

/// _resultMock 1 success, -1 fail, 0 no mock
///
int _resultMock = 0;

/// mockSuccess will let every function success
///
void mockSuccess() {
  _resultMock = 1;
}

/// mockFail will let every function fail
///
void mockFail() {
  _resultMock = -1;
}

/// mockDone stop mock
///
void mockDone() {
  _resultMock = 0;
}

/// isMockSuccess return true if mock success
///
bool isMockSuccess() {
  return _resultMock == 1;
}

/// isMockFail return true if mock fail
///
bool isMockFail() {
  return _resultMock == -1;
}

/// isMock return true if is in mock mode
///
bool isMock() {
  return _resultMock != 0;
}

class WidgetsPlayground extends StatelessWidget {
  Widget hyperText(BuildContext context) {
    return HyperText()
      ..span('HELLO THIS IS MY ')
      ..link('LONG', onTap: (_) => print('hello'))
      ..bold(' remember ')
      ..tip('learn more', 'hello learn more')
      ..span(' SENTENCE ')
      ..doc('privacy', 'privacy');
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => WidgetsPlaygroundProvider(),
      child: Consumer<WidgetsPlaygroundProvider>(
        builder: (context, provider, child) => Scaffold(
            body: Column(
          children: [
            Wrap(
              children: [
                hyperText(context),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class WidgetsPlaygroundProvider {
  final account = TextEditingController();

  final FocusNode focusEmail = FocusNode(debugLabel: 'email');

  WidgetsPlaygroundProvider() {}
}
