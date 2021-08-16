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
      leftBuilder: () => Container(
        color: Colors.red,
        width: 200,
      ),
      centerBuilder: () => Container(color: Colors.yellow),
      sideBuilder: () => Container(
        color: Colors.blue,
        width: 300,
      ),
      bottomBuilder: () => Container(
        color: Colors.green,
        height: 100,
      ),
    );
  }
}
