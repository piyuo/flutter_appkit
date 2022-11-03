import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';

/// TimelineStep is a step in the timeline.
class TimelineStep {
  TimelineStep({
    this.label,
    this.icon,
    this.color = Colors.grey,
    this.show = true,
  });

  /// label for step
  final String? label;

  /// icon for step
  final IconData? icon;

  /// color for step
  final Color color;

  /// show is true will show this step
  final bool show;
}

/// Timeline is a widget that shows a timeline.
class Timeline extends StatelessWidget {
  const Timeline({
    Key? key,
    required this.steps,
    required this.completedIndex,
    this.showLabel = true,
    this.activeBorderColor = Colors.green,
    this.inActiveBorderColor = Colors.grey,
    this.activeLineColor = Colors.green,
    this.inActiveLineColor = Colors.grey,
    this.activeNodeIconColor = Colors.green,
    this.inActiveNodeIconColor = Colors.transparent,
    this.iconSize = 18,
    this.nodeIconSize = 12,
    this.nodeIcon = Icons.check_outlined,
    this.nodeSize = 16,
    this.nodeThickness = 2,
    this.padding = EdgeInsets.zero,
    this.lineHeight = 2,
    this.lineLength = 60,
    this.shape = BoxShape.circle,
    this.activeLabelStyle,
    this.inActiveLabelStyle,
  }) : super(key: key);

  /// steps is The steps to be displayed in the timeline
  final List<TimelineStep> steps;

  /// completedIndex is index of completed step, -1 if no step is completed
  final int completedIndex;

  ///[nodeIcon] size
  final double nodeIconSize;

  /// iconSize is node icon size
  final double iconSize;

  ///Size of each node
  final double nodeSize;

  /// lineHeight of separating line height
  final double lineHeight;

  /// lineLength of separating line length
  final double lineLength;

  ///Icon showed when a step is completed
  final IconData nodeIcon;

  ///Color of each completed node border
  final Color activeBorderColor;

  ///Color of each uncompleted node border
  final Color inActiveBorderColor;

  ///Color of each separating line after a completed node
  final Color activeLineColor;

  ///Color of each separating line after an uncompleted node
  final Color inActiveLineColor;

  ///Background color of a completed node
  final Color activeNodeIconColor;

  ///Background color of an uncompleted node
  final Color inActiveNodeIconColor;

  ///Thickness of node's borders
  final double nodeThickness;

  ///Node's shape
  final BoxShape shape;

  /// padding is timeline default padding
  final EdgeInsets padding;

  /// showLabel is true will show label
  final bool showLabel;

  ///activeLabelStyle for an active label
  final TextStyle? activeLabelStyle;

  ///inActiveLabelStyle for an inactive label
  final TextStyle? inActiveLabelStyle;

  /// isLastStep return true if the step is the last step
  bool isLastStep(int index) => index == steps.length - 1;

  /// isCompleted return true if the step is completed
  bool isCompleted(int index) => completedIndex >= index;

  /// isNextCompleted return true if the next step is completed
  bool isNextCompleted(int index) => completedIndex >= index + 1;

  //returns active or inactive color depending on the completion status of [node]
  Color getColor(int index) => isCompleted(index) ? activeBorderColor : inActiveBorderColor;

  /// side return the side of the node
  BorderSide side(int index) => BorderSide(
        color: getColor(index),
        width: nodeThickness,
      );

  /// getTextStyle return the text style of the label
  TextStyle getTextStyle(int index) {
    if (isCompleted(index)) {
      //return active text style
      return activeLabelStyle ?? TextStyle(color: activeLineColor, fontSize: 8);
    } else {
      //return inactive text style
      return inActiveLabelStyle ?? TextStyle(color: inActiveLineColor, fontSize: 8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = 0; index < steps.length; index++) ...[
            steps[index].show
                ? Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                          height: iconSize,
                          child: steps[index].icon == null || isCompleted(index)
                              ? Container(
                                  alignment: Alignment.center,
                                  height: nodeSize,
                                  width: nodeSize,
                                  decoration: BoxDecoration(
                                    color: isCompleted(index) ? activeNodeIconColor : inActiveNodeIconColor,
                                    border: Border(
                                      bottom: side(index),
                                      top: side(index),
                                      left: side(index),
                                      right: side(index),
                                    ),
                                    shape: shape,
                                  ),
                                  child: isCompleted(index)
                                      ? Icon(
                                          nodeIcon,
                                          size: nodeIconSize,
                                          color: Colors.white,
                                        )
                                      : null,
                                )
                              : Icon(
                                  steps[index].icon!,
                                  size: iconSize,
                                  color: steps[index].color,
                                )),
                      if (showLabel)
                        Positioned(
                          top: 20,
                          left: -((lineLength / 2) - 5),
                          child: Container(
//                              color: Colors.red,
                              alignment: Alignment.center,
                              width: lineLength + 10,
                              child: steps[index].label != null
                                  ? AutoSizeText(
                                      maxLines: 2,
                                      minFontSize: 10,
                                      steps[index].label!,
                                      style: getTextStyle(index),
                                    )
                                  : const SizedBox()),
                        ),
                    ],
                  )
                : SizedBox(
                    height: nodeSize,
                    width: nodeSize,
                  ),
            if (!isLastStep(index))
              DottedLine(
                lineLength: lineLength,
                lineThickness: lineHeight,
                dashLength: 10.0,
                dashColor: isNextCompleted(index) ? activeLineColor : inActiveLineColor,
                dashGapLength: isNextCompleted(index) ? 0 : 5,
                dashGapColor: Colors.transparent,
              ),
          ],
        ],
      ),
    );
  }
}
