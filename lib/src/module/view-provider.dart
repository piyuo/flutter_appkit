import 'package:flutter/widgets.dart';
import 'package:libcli/src/module/async-provider.dart';
import 'package:libcli/src/module/module.dart';

class ViewProvider extends AsyncProvider {
  /// dispatch action and change state
  ///
  ///     var state=provider.dispatch(context,Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    return await Module.of(context).dispatch(context, action);
  }
}
