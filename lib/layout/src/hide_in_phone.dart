import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// HideInPhone won't be displayed in phone
class HideInPhone extends StatelessWidget {
  const HideInPhone({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth < delta.phoneWidth ? const SizedBox() : child;
    });
  }
}
