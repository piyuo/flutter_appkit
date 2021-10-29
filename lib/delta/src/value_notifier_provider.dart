import 'package:flutter/material.dart';

class ValueNotifierProvider<T> with ChangeNotifier {
  ValueNotifierProvider({
    required this.valueNotifier,
  });

  /// controller is for item selection control
  final ValueNotifier<T?>? valueNotifier;

  /// setValue set value to value notifier and notify listeners
  void setValue(context, T key) {
    if (valueNotifier != null) {
      valueNotifier!.value = key;
      notifyListeners();
    }
  }
}
