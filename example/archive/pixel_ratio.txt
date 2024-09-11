import 'package:flutter/material.dart';

class PixelRatio {
  double _ratio = 1;

  PixelRatio(Size designSize, Size logicalSize) {
    setRatio(designSize, logicalSize);
  }

  setRatio(Size designSize, Size logicalSize) {
    _ratio = logicalSize.width > logicalSize.height
        ? logicalSize.height / designSize.height
        : logicalSize.width / designSize.width;
  }

  //@param w is the design w;
  double ratio(double w) {
    return w * _ratio;
  }
}
