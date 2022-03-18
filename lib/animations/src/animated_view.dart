import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animated_grid.dart';
import 'shifter.dart';

/// AnimatedViewItemBuilder is item builder for list or grid
typedef AnimatedViewItemBuilder = Widget Function(bool isListView, int index);

/// AnimatedViewProvider control view's animation
/// ```dart
// return ChangeNotifierProvider<AnimatedViewProvider>(
///       create: (context) => AnimatedViewProvider(),
///       child: Consumer<AnimatedViewProvider>(
///           builder: (context, provide, child) => AnimatedView(
///                   itemBuilder: itemBuilder,
///                   itemCount: gridItems.length,
///                 )),
///     );
/// ```
class AnimatedViewProvider with ChangeNotifier {
  /// AnimatedViewProvider control view's animation
  /// ```dart
// return ChangeNotifierProvider<AnimatedViewProvider>(
  ///       create: (context) => AnimatedViewProvider(),
  ///       child: Consumer<AnimatedViewProvider>(
  ///           builder: (context, provide, child) => AnimatedView(
  ///                   itemBuilder: itemBuilder,
  ///                   itemCount: gridItems.length,
  ///                 )),
  ///     );
  /// ```
  AnimatedViewProvider();

  /// _shifterReverse is true will reverse shifter animation
  bool _shifterReverse = false;

  /// _gridKey is the key of the animated grid
  GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();

  /// nextPageAnimation show next page animation
  void nextPageAnimation() {
    _shifterReverse = false;
    _gridKey = GlobalKey<AnimatedGridState>();
    notifyListeners();
  }

  /// prevPageAnimation show prev page animation
  void prevPageAnimation() {
    _shifterReverse = true;
    _gridKey = GlobalKey<AnimatedGridState>();
    notifyListeners();
  }

  /// insertAnimation show insert animation
  void insertAnimation() {
    _gridKey.currentState!.insertItem(0, duration: animatedDuration);
  }

  /// removeAnimation show remove animation
  void removeAnimation(int index, bool isListView, Widget child) {
    if (index != -1) {
      _gridKey.currentState!.removeItem(
        index,
        (_, animation) => isListView ? _sizeIt(child, animation) : _slideIt(child, animation),
        duration: animatedDuration,
      );
    }
  }
}

/// _slideIt is slide animation
Widget _slideIt(Widget child, animation) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(animation),
    child: SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: child,
    ),
  );
}

/// _slideIt is size animation
Widget _sizeIt(Widget child, animation) {
  return SizeTransition(
    axis: Axis.vertical,
    sizeFactor: animation,
    child: child,
  );
}

/// AnimatedView show animation list or grid
/// ```dart
/// AnimatedView<int>(items: gridItems)
/// ```
class AnimatedView extends StatelessWidget {
  /// AnimatedView show animation list or grid
  /// ```dart
  /// AnimatedView<int>(items: gridItems)
  /// ```
  const AnimatedView({
    required this.itemBuilder,
    required this.itemCount,
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    Key? key,
  }) : super(key: key);

  /// itemCount is total item count
  final int itemCount;

  /// itemBuilder is the item builder
  final AnimatedViewItemBuilder itemBuilder;

  /// crossAxisCount is 1 will show list view, others is grid view
  final int crossAxisCount;

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

  /// isListView return true if crossAxisCount is 1
  bool get isListView => crossAxisCount == 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimatedViewProvider>(
      builder: (context, provide, _) => Shifter(
        reverse: provide._shifterReverse,
        newChildKey: provide._gridKey,
        child: AnimatedGrid(
          shrinkWrap: shrinkWrap,
          key: provide._gridKey,
          crossAxisCount: crossAxisCount,
          initialItemCount: itemCount,
          itemBuilder: (context, index, animation) {
            Widget widget = itemBuilder(isListView, index);
            return _slideIt(widget, animation);
          },
        ),
      ),
    );
  }
}
