import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/responsive/responsive.dart' as responsive;
import 'package:split_view/split_view.dart';
import 'tag_view.dart';

class TagSplitView extends StatelessWidget {
  /// TagSplitView show a tag and content widget in split view
  const TagSplitView({
    required this.tagView,
    required this.child,
    Key? key,
  }) : super(key: key);

  /// tagView is tag view
  final TagView tagView;

  /// child is content widget in split view
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return responsive.isPhoneDesign
        ? child
        : SplitView(
            gripSize: 5,
            gripColor: context.themeColor(
              light: Colors.grey.shade300,
              dark: Colors.grey.shade800,
            ),
            gripColorActive: context.themeColor(
              light: Colors.grey.shade300,
              dark: Colors.grey.shade800,
            ),
            controller: SplitViewController(
              weights: [0.2],
              limits: [WeightLimit(min: 0.15, max: 0.25)],
            ),
            viewMode: SplitViewMode.Horizontal,
            indicator: SplitIndicator(
                viewMode: SplitViewMode.Horizontal,
                color: context.themeColor(
                  light: Colors.grey.shade400,
                  dark: Colors.grey,
                )),
            activeIndicator: const SplitIndicator(
              viewMode: SplitViewMode.Horizontal,
              isActive: true,
              color: Colors.grey,
            ),
            children: [
              tagView,
              child,
            ],
            //onWeightChanged: (w) => onSplitViewResized?.call(constraints.maxWidth * w[0]!),
          );
  }
}
