import 'package:flutter/widgets.dart';
import 'package:libcli/delta.dart' as delta;
import 'module.dart';

class ViewProvider extends delta.AsyncProvider {
  /// dispatch action and change state
  ///
  ///     var state=provider.dispatch(context,Increment(1));
  ///
  Future<Map> dispatch(BuildContext context, dynamic action) async {
    return await Module.of(context).dispatch(context, action);
  }
}
