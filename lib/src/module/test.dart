import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'redux.dart';

Future<Map> mockReducers(BuildContext context, Map oldState, dynamic action) async {
  return oldState;
}

/// MockRedux extends redux to do test
///
class MockRedux extends Redux {
  dynamic lastAction;

  dynamic previousAction;

  /// MockRedux constructor with default state
  ///
  MockRedux(Map state) : super(mockReducers, state);

  /// logInitState no log in mock
  ///
  @override
  void logInitState() {}

  @override
  Future<void> dispatch(BuildContext context, dynamic action) async {
    previousAction = lastAction;
    lastAction = action;
  }
}
