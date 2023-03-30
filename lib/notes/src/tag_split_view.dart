import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:split_view/split_view.dart';
import 'tag_view.dart';

class TagSplitView extends StatelessWidget {
  /// TagSplitView show a tag and content widget in split view on big screen
  const TagSplitView({
    required this.child,
    this.tagView,
    Key? key,
  }) : super(key: key);

  /// tagView is tag view, if tag view is null it will show child directly
  final TagView? tagView;

  /// child is content widget in split view
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (tagView == null) {
      return child;
    }
    final colorScheme = Theme.of(context).colorScheme;
    return delta.Responsive(
        phoneScreen: () => child,
        bigScreen: () => SplitView(
              gripSize: 5,
              gripColor: colorScheme.outlineVariant.withOpacity(.2),
              gripColorActive: colorScheme.outlineVariant.withOpacity(.5),
              controller: SplitViewController(
                weights: [0.15],
                limits: [WeightLimit(min: 0.15, max: 0.25)],
              ),
              viewMode: SplitViewMode.Horizontal,
              indicator: SplitIndicator(
                viewMode: SplitViewMode.Horizontal,
                color: colorScheme.outlineVariant.withOpacity(.9),
              ),
              activeIndicator: SplitIndicator(
                viewMode: SplitViewMode.Horizontal,
                isActive: true,
                color: colorScheme.outlineVariant,
              ),
              children: [
                tagView!,
                child,
              ],
            ));
  }
}
