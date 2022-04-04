import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animated_grid.dart';
import 'shifter.dart';

/// AnimatedViewItemBuilder is item builder for list or grid
typedef AnimatedViewItemBuilder = Widget Function(bool isListView, int index);

/// AnimatedViewProvider control view's animation
/// ```dart
/// return ChangeNotifierProvider<AnimatedViewProvider>(
///       create: (context) => AnimatedViewProvider(gridItems.length),
///       child: Consumer<AnimatedViewProvider>(
///           builder: (context, provide, child) => AnimatedView(
///                   itemBuilder: itemBuilder,
///                 )),
///     );
/// ```
class AnimatedViewProvider with ChangeNotifier {
  /// AnimatedViewProvider control view's animation
  /// ```dart
  /// return ChangeNotifierProvider<AnimatedViewProvider>(
  ///       create: (context) => AnimatedViewProvider(gridItems.length),
  ///       child: Consumer<AnimatedViewProvider>(
  ///           builder: (context, provide, child) => AnimatedView(
  ///                   itemBuilder: itemBuilder,
  ///                 )),
  ///     );
  /// ```
  AnimatedViewProvider(count) {
    itemCount = count;
  }

  /// itemCount is total item count
  int _itemCount = 0;

  set itemCount(int value) {
    _itemCount = value;
    if (_gridKey.currentState != null) {
      _gridKey.currentState!.itemCount = _itemCount;
    }
    notifyListeners();
  }

  /// _shifterReverse is true will reverse shifter animation
  bool _shifterReverse = false;

  /// _shifterVertical is true will use vertical shifter animation
  bool _shifterVertical = false;

  /// _gridKey is the key of the animated grid
  GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();

  /// refreshPageAnimation show refresh page animation
  void refreshPageAnimation() {
    _shifterReverse = true;
    _shifterVertical = true;
    _gridKey = GlobalKey<AnimatedGridState>();
    notifyListeners();
  }

  /// nextPageAnimation show next page animation
  void nextPageAnimation() {
    _shifterReverse = false;
    _shifterVertical = false;
    _gridKey = GlobalKey<AnimatedGridState>();
    notifyListeners();
  }

  /// prevPageAnimation show prev page animation
  void prevPageAnimation() {
    _shifterReverse = true;
    _shifterVertical = false;
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
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    this.controller,
    Key? key,
  }) : super(key: key);

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

  /// isListView return true if crossAxisCount is 1
  bool get isListView => crossAxisCount == 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimatedViewProvider>(
      builder: (context, provide, _) => Shifter(
        reverse: provide._shifterReverse,
        vertical: provide._shifterVertical,
        newChildKey: provide._gridKey,
        child: AnimatedGrid(
          controller: controller,
          shrinkWrap: shrinkWrap,
          key: provide._gridKey,
          crossAxisCount: crossAxisCount,
          initialItemCount: provide._itemCount,
          itemBuilder: (context, index, animation) {
            Widget widget = itemBuilder(isListView, index);
            return _slideIt(widget, animation);
          },
        ),
      ),
    );
  }
}
