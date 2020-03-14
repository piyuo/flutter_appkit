import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/error/error.dart' as error;

class ErrorCatch extends StatelessWidget {
  final Widget child;

  ErrorCatch({@required this.child});

  @override
  Widget build(BuildContext context) {
    error.catchContext = context;
    return child;
  }
}
