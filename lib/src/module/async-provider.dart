import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart';

enum AsyncStatus { none, loading, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncProvider() {
    if (!kReleaseMode) {
      log('${COLOR_MEMORY}$runtimeType${COLOR_END} created');
    }
  }

  AsyncStatus asyncStatus = AsyncStatus.none;

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
    if (!kReleaseMode) {
      log('${COLOR_MEMORY}$runtimeType${COLOR_END} disposed');
    }
    _disposed = true;
    super.dispose();
  }
}
