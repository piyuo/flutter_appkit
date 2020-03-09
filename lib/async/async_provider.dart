import 'package:flutter/material.dart';
import 'package:libcli/log/log.dart';

const here = 'async/await';

enum AsyncStatus { wait, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncStatus asyncStatus = AsyncStatus.wait;

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
    '$here|dispose $NOUN$runtimeType'.print;
    _disposed = true;
    super.dispose();
  }
}
