import 'package:flutter/widgets.dart';

/// BoolProvider control bool value
class BoolProvider with ChangeNotifier {
  void setValue(bool value) {
    _value = value;
    notifyListeners();
  }

  bool _value = false;

  bool get value => _value;
}
