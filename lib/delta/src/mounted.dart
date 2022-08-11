import 'package:flutter/material.dart';

/// Mounted provide a way to get mounted variable to detect context is valid
class Mounted extends StatefulWidget {
  const Mounted({
    required this.builder,
    Key? key,
  }) : super(key: key);

  final Widget Function(BuildContext context, bool mounted, Function() safePop) builder;

  @override
  MountedState createState() => MountedState();
}

class MountedState extends State<Mounted> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, mounted, safePop);
  }

  /// safeNavigatorPop will check mounted to safely pop navigator
  void safePop() {
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
