import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class DialogOverlay extends StatelessWidget {
  final Widget child;

  DialogOverlay({@required this.child});

  @override
  Widget build(BuildContext context) {
    return OKToast(child: child);
  }
}
