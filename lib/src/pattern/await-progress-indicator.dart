import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AwaitProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange))),
    );
  }
}
