import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// paddingToTablet set padding so remain space is tablet width
EdgeInsets paddingToTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > delta.tabletDesignMax) {
    final space = (width - delta.tabletDesignMax) / 2;
    return EdgeInsets.symmetric(horizontal: space);
  }
  return EdgeInsets.zero;
}
