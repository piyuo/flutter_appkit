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

  /// voidFunc add break on callback, if one callback is running the others will be disable
  void Function()? voidFunc<T>(Future Function()? callback) {
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

  /// valueFunc add break on callback, if one callback is running the others will be disable
  ValueChanged<T?>? valueFunc<T>(Future Function(T? value)? callback) {
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

  /// futureContextFunc add break on callback, if one callback is running the others will be disable
  Future<void> Function(BuildContext)? futureContextFunc<T>(Future<void> Function(BuildContext)? callback) {
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

  /// futureFunc add break on future callback, if one callback is running the others will be disable
  Future<void> Function()? futureFunc<T>(Future<void> Function()? callback) {
    if (_busy || callback == null) {
      return null;
    }
    return () async {
      setBusy(true);
      try {
        await callback();
      } finally {
        setBusy(false);
      }
    };
  }
}
