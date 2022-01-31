import 'package:flutter/material.dart';

/// paddingToCenter set padding to screen width - max width
EdgeInsets paddingToCenter(BuildContext context, double maxWidth) {
  final width = MediaQuery.of(context).size.width;
  if (width > maxWidth) {
    final space = (width - maxWidth) / 2;
    return EdgeInsets.symmetric(horizontal: space);
  }
  return EdgeInsets.zero;
}
