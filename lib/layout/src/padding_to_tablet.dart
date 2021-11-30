import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// paddingToTablet set padding so remain space is tablet width
EdgeInsets paddingToTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > delta.tabletWidth) {
    final space = (width - delta.tabletWidth) / 2;
    debugPrint('paddingToTablet: $space');
    return EdgeInsets.only(left: space, right: space);
  }
  return EdgeInsets.zero;
}
