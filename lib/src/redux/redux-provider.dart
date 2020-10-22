import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/src/redux/async-provider.dart';
import 'package:libcli/src/redux/redux.dart';
import 'package:libcli/log.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/eventbus.dart' as eventbus;

/// ReduxProvider implement AsyncProvicer and Redux
///
abstract class ReduxProvider extends AsyncProvider {
  /// redux instance
  ///
  Redux _redux;

  /// dispose remove  redux instances list
  ///
  @override
  void dispose() {
    if (_redux != null) {
      reduxStates.remove(_redux.state);
      _redux = null;
    }
    super.dispose();
  }

  /// ReduxProvider constructor with default reducer and state
  ///
  set redux(Redux rx) {
    assert(rx != null, 'redux must no be null');

    if (_redux != null) {
      reduxStates.remove(_redux.state);
    }
    _redux = rx;
    reduxStates.add(_redux.state);
  }

  get redux {
    assert(_redux != null, 'redux must no be null');
    return _redux;
  }

  /// state return current redux state
  ///
  Map get state {
    return redux.state;
  }

  /// dispatch action and change state
  ///
  ///     redux.dispatch(context,Increment(1));
  ///
  @mustCallSuper
  void dispatch(BuildContext ctx, dynamic action) async {
    await _redux.dispatch(ctx, action);
  }

  /// checkErrState check state['err'] return true if no error, brodcast [ShowErrorEvent] if receive error code
  ///
  bool checkErrState(BuildContext context) {
    String err = state['err'];
    if (err == null) {
      return false;
    } else if (err != '') {
      eventbus.broadcast(context, eventbus.ShowErrorEvent(err.i18n(context)));
      return false;
    }
    return true;
  }
}
