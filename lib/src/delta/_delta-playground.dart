import 'package:flutter/material.dart';
import '../component/bar.dart';

class DeltaPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Bar(
        title: Text('bar'),
        backToRoot: true,
      ),
      body: SafeArea(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
                  colors: [const Color(0xffee0000), const Color(0xffeeee00)], // red to yellow
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [],
              ))),
    );
  }
}
