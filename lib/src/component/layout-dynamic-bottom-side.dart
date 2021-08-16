import 'package:flutter/material.dart';

class LayoutDynamicBottomSide extends StatelessWidget {
  LayoutDynamicBottomSide({
    required this.left,
    required this.center,
    required this.side,
    required this.bottom,
    this.bottomConstraint: 900,
    this.maxWidth: 1920,
    this.leftWidthOnBottom: 200,
    this.leftWidthOnSide: 300,
  });

  /// bottomConstraint will show bottom when layout is smaller than bottomConstraint
  final double bottomConstraint;

  ///  maxWidth set layout max width
  final double maxWidth;

  ///  leftWidthOnBottom set left width when bottom is shown
  final double leftWidthOnBottom;

  ///  leftWidthOnSide set left width when side is shown
  final double leftWidthOnSide;

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
      var bottomVisible = constraints.maxWidth < bottomConstraint;
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
                    SizedBox(
                      width: bottomVisible ? leftWidthOnBottom : leftWidthOnSide,
                      child: left,
                    ),
                    Expanded(
                      child: center,
                    ),
                    bottomVisible ? SizedBox() : side,
                  ],
                ),
              ),
              bottomVisible
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
