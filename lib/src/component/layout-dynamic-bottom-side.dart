import 'package:flutter/material.dart';

class DynamicSideLayout extends StatelessWidget {
  final double _miniLayoutConstraint = 900;

//  final double _maxLayoutConstraint = 1600;
  final double _maxLayoutConstraint = 1920;

  DynamicSideLayout({
    required this.left,
    required this.center,
    required this.right,
    required this.bottom,
  });

  final Widget left;

  final Widget center;

  final Widget right;

  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      var miniLayout = constraints.maxWidth < _miniLayoutConstraint;
      return Align(
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(maxWidth: _maxLayoutConstraint),
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            alignment: AlignmentDirectional.topEnd,
            children: [
              Positioned.fill(
                child: _body(context, miniLayout),
              ),
              miniLayout
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: bottom,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    });
  }

  Widget _body(BuildContext context, bool noSide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: left,
        ),
        Expanded(
          flex: 14,
          child: center,
        ),
        Expanded(
          flex: noSide ? 0 : 4,
          child: right,
        ),
      ],
    );
  }
}
