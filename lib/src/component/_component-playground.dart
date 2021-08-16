import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/custom-icons.dart';
import 'package:libcli/play.dart' as play;
import 'layout-dynamic-bottom-side.dart';

class ComponentPlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            play.example(
              context,
              text: 'layout-dynamic-bottom-side',
              child: _layoutDynamicBottomSide(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutDynamicBottomSide() {
    return LayoutDynamicBottomSide(
      bottomConstraint: 900,
      maxWidth: 1200,
      left: Container(
        color: Colors.red,
        width: 200,
      ),
      center: Container(color: Colors.yellow),
      side: Container(
        color: Colors.blue,
        width: 300,
      ),
      bottom: Container(
        color: Colors.green,
        height: 100,
      ),
    );
  }
}
