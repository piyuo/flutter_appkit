import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/custom-icons.dart';

class ComponentPlayground extends StatelessWidget {
  Widget _show(BuildContext context, String text, void Function() callback) {
    return ElevatedButton(child: Text(text), onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            _show(context, 'hello', () => print('hello')),
          ],
        ),
      ),
    );
  }
}
