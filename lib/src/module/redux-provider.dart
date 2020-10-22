import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/module.dart';
import 'package:libcli/log.dart';

/// ReduxProvider implement AsyncProvicer and Redux
///
class ReduxProvider extends ChangeNotifier {
  /// redux instance
  ///
  Redux redux;

  ReduxProvider(this.redux) {
    assert(redux != null, 'redux must no be null');
  }

  /// dispose remove  redux instances list
  ///
  @override
  void dispose() {
    reduxStates.remove(redux.state);
    super.dispose();
  }

  /// state return current redux state
  ///
  Map get state {
    return redux.state;
  }

  /// dispatch action and change state
  ///
  ///     provider.dispatch(context,Increment(1));
  ///
  Future<void> dispatch(BuildContext ctx, dynamic action) async {
    await redux.dispatch(ctx, action);
  }
}
