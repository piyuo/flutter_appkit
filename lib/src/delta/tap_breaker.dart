import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// TapBreak will break all concatenate callback if one callback is running
class TapBreaker with ChangeNotifier {
  bool _busy = false;

  void setBusy(bool value) {
    if (_busy != value) {
      _busy = value;
      notifyListeners();
    }
  }

  /// link add break on callback, if one callback is running the others will be disable
  GestureTapCallback? link(Future Function()? callback) {
    if (_busy || callback == null) {
      return null;
    }
    return () async {
      setBusy(true);
      notifyListeners();
      try {
        await callback();
      } finally {
        setBusy(false);
      }
    };
  }

  /// linkValueChanged add break on callback, if one callback is running the others will be disable
  ValueChanged<T?>? linkValueChanged<T>(Future Function(T? value)? callback) {
    if (_busy || callback == null) {
      return null;
    }
    return (T? value) async {
      setBusy(true);
      try {
        await callback(value);
      } finally {
        setBusy(false);
      }
    };
  }
}
