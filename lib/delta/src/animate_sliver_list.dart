import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_animated/auto_animated.dart';

/// _AnimateSliverListProvider is A provider for AnimateSliverList
class _AnimateSliverListProvider with ChangeNotifier {
  /// scrollController is A scroll controller for LiveSliverList
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

/// AnimateSliverList make an animated on scroll widgets
class AnimateSliverList extends StatelessWidget {
  const AnimateSliverList({
    this.visibleFraction = 0.9,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  /// visibleFraction is A fraction in the range [0, 1] that represents what proportion of the widget is visible (assuming rectangular bounding boxes).
  /// 0 means not visible; 1 means fully visible.
  final double visibleFraction;

  /// itemCount is The number of items the list will start with
  final int itemCount;

  /// itemBuilder is A builder that builds children for this widget given this widget's context and the index of the child to build.
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_AnimateSliverListProvider>(
        create: (context) => _AnimateSliverListProvider(),
        child: Consumer<_AnimateSliverListProvider>(builder: (context, animateSliverListProvider, _) {
          return LiveSliverList(
            controller: animateSliverListProvider.scrollController,
            visibleFraction: visibleFraction,
            itemCount: itemCount,
            itemBuilder: (context, recordIndex, animation) {
              return FadeTransition(
                opacity: Tween<double>(
                  begin: 0,
                  end: 1,
                ).animate(animation),
                // And slide transition
                child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: itemBuilder(context, recordIndex)),
              );
            },
          );
        }));
  }
}
