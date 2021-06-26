import 'package:flutter/widgets.dart';

/// BoolProvider control bool value
class BoolProvider with ChangeNotifier {
  void setValue(bool value) {
    boolValue = value;
    notifyListeners();
  }

  @protected
  bool boolValue = false;

  bool get value => boolValue;
}
