import 'package:flutter/material.dart';

class ViewController with ChangeNotifier {
  bool _isListView = true;

  bool _isSelecting = false;

  bool get isSelecting => _isSelecting;

  set isSelecting(bool value) {
    _isSelecting = value;
    notifyListeners();
  }

  bool get isListView => _isListView;

  set isListView(bool value) {
    _isListView = value;
    notifyListeners();
  }
}
