import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/custom-icons.dart';
import 'package:libcli/play.dart' as play;
import 'dynamic-bottom-side.dart';
import 'fitted-grid.dart';

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
            play.example(
              context,
              text: 'fitted-grid',
              child: _fittedGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutDynamicBottomSide() {
    return DynamicBottomSide(
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

  Widget _fittedGrid() {
    return FittedGrid(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          color: Colors.red,
        ),
        Fitted(
          child: Container(
            color: Colors.blue,
          ),
        ),
        Fitted(
          child: Container(
            color: Colors.yellow,
          ),
        ),
        Fitted(
          child: Container(
            color: Colors.green,
          ),
        ),
        Fitted(
          child: Container(
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
