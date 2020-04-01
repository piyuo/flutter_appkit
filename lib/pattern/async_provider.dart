import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';
import 'package:flutter/foundation.dart';

const here = 'async_provider';

enum AsyncStatus { none, loading, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncProvider() {
    debugPrint('$here|$runtimeType ${VERB}created');
  }

  AsyncStatus asyncStatus = AsyncStatus.none;

  /// prevent notifyListeners after dispose
  bool _disposed = false;

  /// load happen when object created
  ///
  Future<void> load() async {}

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    debugPrint('$here|$runtimeType ${VERB}disposed');
    _disposed = true;
    super.dispose();
  }
}
