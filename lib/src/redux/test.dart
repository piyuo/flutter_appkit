import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:libcli/src/redux/redux.dart';

Future<Map> _mock_reducers(BuildContext context, Map oldState, dynamic action) async {
  return oldState;
}

/// MockRedux extends redux to do test
///
class MockRedux extends Redux {
  dynamic lastAction;

  dynamic previousAction;

  /// MockRedux constructor with default state
  ///
  MockRedux(Map state) : super(_mock_reducers, state);

  /// logInitState no log in mock
  ///
  @override
  void logInitState() {}

  Future<void> dispatch(BuildContext context, dynamic action) async {
    previousAction = lastAction;
    lastAction = action;
  }
}
