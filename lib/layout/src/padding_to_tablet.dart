import 'package:flutter/material.dart';
import 'package:libcli/responsive/responsive.dart' as responsive;

/// paddingToTablet set padding so remain space is tablet width
EdgeInsets paddingToTablet(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width > responsive.phoneDesignMax) {
    final space = (width - responsive.phoneDesignMax) / 2;
    return EdgeInsets.symmetric(horizontal: space);
  }
  return EdgeInsets.zero;
}
