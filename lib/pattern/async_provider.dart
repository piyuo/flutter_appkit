import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';

const here = 'async_provider';

enum AsyncStatus { none, loading, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncProvider() {
    '$here|$runtimeType ${VERB}created'.print;
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
    '$here|$runtimeType ${VERB}disposed'.print;
    _disposed = true;
    super.dispose();
  }
}
