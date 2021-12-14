import 'package:flutter/widgets.dart';

/// TapBreak will break all concatenate callback if one callback is running
class TapBreaker with ChangeNotifier {
  bool _busy = false;

  void setBusy(bool value) {
    if (_busy != value) {
      _busy = value;
      notifyListeners();
    }
  }

  /// linkVoidFunc add break on callback, if one callback is running the others will be disable
  void Function()? linkVoidFunc<T>(Future Function()? callback) {
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

  /// linkValueFunc add break on callback, if one callback is running the others will be disable
  ValueChanged<T?>? linkValueFunc<T>(Future Function(T? value)? callback) {
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

  /// linkFutureContextFunc add break on callback, if one callback is running the others will be disable
  Future<void> Function(BuildContext)? linkFutureContextFunc<T>(Future<void> Function(BuildContext)? callback) {
    if (_busy || callback == null) {
      return null;
    }
    return (BuildContext context) async {
      setBusy(true);
      try {
        await callback(context);
      } finally {
        setBusy(false);
      }
    };
  }
}
