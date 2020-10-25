import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/eventbus.dart' as eventbus;

class ViewProvider extends AsyncProvider {
  /// dispatch action and change state
  ///
  ///     var state=provider.dispatch(context,Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    final module = Provider.of<ModuleProvider>(context, listen: false);
    assert(module != null, 'module provider not found');
    await module.dispatch(context, action);
    return module.state;
  }

  /// errCheck check redux state['err'] return true if no error, brodcast [ShowErrorEvent] if receive error code
  ///
  bool errCheck(BuildContext context) {
    final module = Provider.of<ModuleProvider>(context, listen: false);
    assert(module != null, 'module provider not found');

    String err = module.state['err'];
    if (err == null) {
      return false;
    } else if (err != '') {
      eventbus.broadcast(context, eventbus.ShowErrorEvent(err.i18n(context)));
      return false;
    }
    return true;
  }
}
