import 'package:flutter/widgets.dart';

class BoolEditingController {
  bool _value = false;

  ValueChanged<bool?>? onChanged;

  BoolEditingController({bool newValue = false, this.onChanged}) {
    _value = newValue;
  }

  bool get value {
    return _value;
  }

  set value(bool newValue) {
    if (newValue != _value) {
      _value = newValue;
      if (onChanged != null) {
        onChanged!(newValue);
      }
    }
  }
}
