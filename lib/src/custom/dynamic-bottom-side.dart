import 'package:flutter/material.dart';

class DynamicBottomSide extends StatelessWidget {
  DynamicBottomSide({
    required this.leftBuilder,
    required this.centerBuilder,
    required this.sideBuilder,
    required this.bottomBuilder,
    this.showBottomWhenWidth: 600,
    this.maxWidth: 1920,
    this.leftWidthOnBottom: 130,
    this.leftWidthOnSide: 300,
  });

  /// bottomConstraint will show bottom when layout is smaller than bottomConstraint
  final double showBottomWhenWidth;

  ///  maxWidth set layout max width
  final double maxWidth;

  ///  leftWidthOnBottom set left width when bottom is shown
  final double leftWidthOnBottom;

  ///  leftWidthOnSide set left width when side is shown
  final double leftWidthOnSide;

  /// left widget
  final Widget Function() leftBuilder;

  /// centerBuilder build center widget
  final Widget Function() centerBuilder;

  /// sideBuilder build side widget
  final Widget Function() sideBuilder;

  /// bottomBuilder build bottom widget
  final Widget Function() bottomBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      var bottomVisible = constraints.maxWidth < showBottomWhenWidth;
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
                      child: leftBuilder(),
                    ),
                    Expanded(
                      child: centerBuilder(),
                    ),
                    bottomVisible ? SizedBox() : sideBuilder(),
                  ],
                ),
              ),
              bottomVisible
                  ? Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: bottomBuilder(),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
