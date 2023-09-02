import 'package:flutter/material.dart';
import 'animate_grid.dart';
import 'shifter.dart';
import 'animate_view_provider.dart';

/// AnimateView show animation list or grid
class AnimateView extends StatelessWidget {
  /// AnimateView show animation list or grid
  /// ```dart
  /// AnimateView<int>(items: gridItems)
  /// ```
  const AnimateView({
    required this.gridKey,
    required this.length,
    required this.itemBuilder,
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    this.controller,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    Key? key,
  }) : super(key: key);

  /// itemBuilder is builder use index to build item
  final Widget Function(int index) itemBuilder;

  /// crossAxisCount is 1 will show list view, others is grid view
  final int crossAxisCount;

  /// mainAxisSpacing for grid is the number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// crossAxisSpacing for grid is the number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// childAspectRatio for grid is the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController? controller;

  /// length is [AnimateViewProvider]'s length
  final int length;

  /// gridKey is the key of the animated grid
  final GlobalKey<AnimateGridState> gridKey;

  @override
  Widget build(BuildContext context) {
    return AnimateGrid(
      controller: controller,
      shrinkWrap: shrinkWrap,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      key: gridKey,
      crossAxisCount: crossAxisCount,
      initialItemCount: length,
      itemBuilder: (context, index, animation) {
        Widget widget = itemBuilder(index);
        return slideIt(widget, animation);
      },
    );
  }
}

/// AnimateShiftView show shift animation list or grid
class AnimateShiftView extends StatelessWidget {
  const AnimateShiftView({
    required this.gridKey,
    required this.length,
    required this.itemBuilder,
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    this.controller,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    this.shifterReverse = false,
    this.shifterVertical = false,
    Key? key,
  }) : super(key: key);

  /// itemBuilder is builder use index to build item
  final Widget Function(int index) itemBuilder;

  /// crossAxisCount is 1 will show list view, others is grid view
  final int crossAxisCount;

  /// mainAxisSpacing for grid is the number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// crossAxisSpacing for grid is the number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;

  /// childAspectRatio for grid is the cross-axis to the main-axis extent of each child.
  final double childAspectRatio;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController? controller;

  /// shifterReverse is true will reverse shifter animation
  final bool shifterReverse;

  /// shifterVertical is true will use vertical shifter animation
  final bool shifterVertical;

  /// length is [AnimateViewProvider]'s length
  final int length;

  /// gridKey is the key of the animated grid
  final GlobalKey<AnimateGridState> gridKey;

  @override
  Widget build(BuildContext context) {
    return Shifter(
      reverse: shifterReverse,
      vertical: shifterVertical,
      newChildKey: gridKey,
      child: AnimateGrid(
        controller: controller,
        shrinkWrap: shrinkWrap,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        key: gridKey,
        crossAxisCount: crossAxisCount,
        initialItemCount: length,
        itemBuilder: (context, index, animation) {
          Widget widget = itemBuilder(index);
          return slideIt(widget, animation);
        },
      ),
    );
  }
}
