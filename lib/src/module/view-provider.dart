import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/module.dart';
import 'package:libcli/redux.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/eventbus.dart' as eventbus;

class ViewProvider extends AsyncProvider {
  /// dispatch action and change state
  ///
  ///     var state=provider.dispatch(context,Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    final redux = Provider.of<ReduxProvider>(context, listen: false);
    assert(redux != null, 'redux provider not found');
    await redux.dispatch(context, action);
    return redux.state;
  }

  /// errCheck check redux state['err'] return true if no error, brodcast [ShowErrorEvent] if receive error code
  ///
  bool errCheck(BuildContext context) {
    final redux = Provider.of<ReduxProvider>(context, listen: false);
    assert(redux != null, 'redux provider not found');

    String err = redux.state['err'];
    if (err == null) {
      return false;
    } else if (err != '') {
      eventbus.broadcast(context, eventbus.ShowErrorEvent(err.i18n(context)));
      return false;
    }
    return true;
  }
}
