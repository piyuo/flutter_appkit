import 'package:flutter/material.dart';
import 'package:libcli/module.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/eventbus.dart' as eventbus;

class ViewProvider extends AsyncProvider {
  /// checkErr check state['err'] return true if no error, brodcast [ShowErrorEvent] if receive error code
  ///
  bool checkErr(BuildContext context, Map state) {
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
