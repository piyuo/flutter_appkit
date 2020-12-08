import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:libcli/module.dart';

class ViewProvider extends AsyncProvider {
  /// dispatch action and change state
  ///
  ///     var state=provider.dispatch(context,Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    final module = Provider.of<ModuleProvider>(context, listen: false);
    return await module.dispatch(context, action);
  }
}
