import 'package:flutter/widgets.dart';

/// VisibilityProvider control visible value
class VisibilityProvider with ChangeNotifier {
  void setVisible(bool visible) {
    _visible = visible;
    notifyListeners();
  }

  bool _visible = false;

  bool get visible => _visible;
}
