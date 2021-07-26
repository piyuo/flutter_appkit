import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart' as log;

enum AsyncStatus { none, loading, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncProvider() {
    log.log('${log.COLOR_MEMORY}$description${log.COLOR_END} created');
  }

  @protected
  String get description => '$runtimeType';

  AsyncStatus asyncStatus = AsyncStatus.none;

  /// prevent notifyListeners after dispose
  bool _disposed = false;

  /// load happen when Await initState()
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
      log.log('${log.COLOR_MEMORY}$description${log.COLOR_END} disposed');
    }
    _disposed = true;
    super.dispose();
  }

  /// resetStatus reset async status and force provider to load again
  void resetStatus() {
    asyncStatus = AsyncStatus.none;
  }
}
