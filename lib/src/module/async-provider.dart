import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart';

const here = 'async_provider';

enum AsyncStatus { none, loading, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncProvider() {
    debugPrint('$here~${ALLOCATION}$runtimeType created');
  }

  AsyncStatus asyncStatus = AsyncStatus.none;

  ErrorReport? errorReport = null;

  /// prevent notifyListeners after dispose
  bool _disposed = false;

  /// load happen when Await  initState()
  ///
  Future<void> load(BuildContext context) async {}

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('$here~${ALLOCATION}$runtimeType disposed');
    _disposed = true;
    super.dispose();
  }
}
