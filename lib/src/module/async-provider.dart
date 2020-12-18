import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/log.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

enum AsyncStatus { none, loading, ready, error }

abstract class AsyncProvider with ChangeNotifier {
  AsyncProvider() {
    if (!kReleaseMode) {
      if (!Platform.environment.containsKey('FLUTTER_TEST')) {
        log('${COLOR_MEMORY}$description${COLOR_END} created');
      }
    }
  }

  @protected
  String get description => '$runtimeType';

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
      if (!Platform.environment.containsKey('FLUTTER_TEST')) {
        log('${COLOR_MEMORY}$description${COLOR_END} disposed');
      }
    }
    _disposed = true;
    super.dispose();
  }
}
