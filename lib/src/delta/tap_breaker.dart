import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// TapBreak will break all concatenate callback if one callback is running
class TapBreaker with ChangeNotifier {
  bool _running = false;

  /// link add break on callback, if one callback is running the others will be disable
  GestureTapCallback? link(Future<dynamic> Function()? callback) {
    if (_running || callback == null) {
      return null;
    }
    return () async {
      _running = true;
      notifyListeners();
      try {
        await callback();
      } finally {
        _running = false;
        notifyListeners();
      }
    };
  }
}
