import 'package:flutter/material.dart';

class LayoutDynamicBottomSide extends StatelessWidget {
  LayoutDynamicBottomSide({
    required this.left,
    required this.center,
    required this.side,
    required this.bottom,
    this.bottomConstraint: 900,
    this.maxWidth: 1920,
  });

  /// bottomConstraint will show bottom when layout is smaller than bottomConstraint
  final double bottomConstraint;

  ///  maxWidth set layout max width
  final double maxWidth;

  /// left widget
  final Widget left;

  /// center widget
  final Widget center;

  /// side widget
  final Widget side;

  /// bottom widget
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      var showBottom = constraints.maxWidth < bottomConstraint;
      return Align(
        alignment: Alignment.center,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            alignment: AlignmentDirectional.topEnd,
            children: [
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    left,
                    Expanded(
                      child: center,
                    ),
                    showBottom ? SizedBox() : side,
                  ],
                ),
              ),
              showBottom
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
}
