import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animate_grid.dart';
import 'shifter.dart';

/// shakeShift is for shift animation
const shakeShift = 10.0;

/// AnimatedViewProvider control view's animation
class AnimateViewProvider with ChangeNotifier {
  /// of get DatabaseProvider from context
  static AnimateViewProvider of(BuildContext context) {
    return Provider.of(context, listen: false);
  }

  /// _length is items length in view
  int _length = 0;

  /// length return items length in view
  int get length => _length;

  /// setLength set new item length in view, notify is true will notify listener
  void setLength(int value, {bool notify = false}) {
    _length = value;
    if (_gridKey.currentState != null) {
      _gridKey.currentState!.itemCount = _length;
    }
    if (notify) {
      notifyListeners();
    }
  }

  /// _shifterReverse is true will reverse shifter animation
  bool _shifterReverse = false;

  /// _shifterVertical is true will use vertical shifter animation
  bool _shifterVertical = false;

  /// _gridKey is the key of the animated grid
  GlobalKey<AnimateGridState> _gridKey = GlobalKey<AnimateGridState>(debugLabel: 'animateGridKey');

  /// refreshPageAnimation show refresh page animation
  void refreshPageAnimation(newPageLength) {
    _shifterReverse = true;
    _shifterVertical = true;
    _gridKey = GlobalKey<AnimateGridState>();
    _length = newPageLength;
    notifyListeners();
  }

  /// nextPageAnimation show next page animation
  void nextPageAnimation(int nextPageLength) {
    _shifterReverse = false;
    _shifterVertical = false;
    _gridKey = GlobalKey<AnimateGridState>();
    _length = nextPageLength;
    notifyListeners();
  }

  /// prevPageAnimation show prev page animation
  void prevPageAnimation(int prevPageLength) {
    _shifterReverse = true;
    _shifterVertical = false;
    _gridKey = GlobalKey<AnimateGridState>();
    _length = prevPageLength;
    notifyListeners();
  }

  /// insertAnimation show insert animation
  void insertAnimation({int? index, int count = 1, Duration? duration}) {
    _length += count;
    if (_gridKey.currentState != null) {
      for (int i = 0; i < count; i++) {
        _gridKey.currentState!.insertItem(index ?? 0, duration: duration ?? animatedDuration);
      }
    }
  }

  /// removeAnimation show remove animation
  void removeAnimation(
    int index,
    Widget child, {
    bool isSizeAnimation = true,
    Duration? duration,
  }) {
    if (index != -1 && _gridKey.currentState != null) {
      _gridKey.currentState!.removeItem(
        index,
        (context, animation) => isSizeAnimation ? _sizeIt(child, animation) : _slideIt(child, animation),
        duration: duration ?? animatedDuration,
      );
      _length--;
    }
  }

  /// shakeAnimation show shake animation
  void shakeAnimation(int index) {
    if (index != -1 && _gridKey.currentState != null) {
      _gridKey.currentState!.shakeItem(
        index,
        (context, animation, child) => _shakeIt(child, animation),
        duration: animatedDuration,
      );
    }
  }

  /// waitForAnimationDone will wait for animation done
  Future<void> waitForAnimationDone() async {
    // wait a little longer to make sure animation is done
    await Future.delayed(Duration(milliseconds: animatedDuration.inMilliseconds + 300));
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

/*
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
 */

/// _slideIt is size animation
Widget _sizeIt(Widget child, animation) {
  return SizeTransition(
    axis: Axis.vertical,
    sizeFactor: animation,
    child: child,
  );
}

/// _shakeIt is shake animation
Widget _shakeIt(Widget child, animation) {
  final curve = CurveTween(curve: Curves.elasticIn);
  double shake(double animation) => 2 * (0.5 - (0.5 - curve.transform(animation)).abs());
  return AnimatedBuilder(
      animation: animation,
      builder: (buildContext, _) {
        final aValue = shake(animation.value) * shakeShift;
        return Transform.translate(
          offset: Offset(aValue, 0),
          child: child,
        );
      });
}

/// AnimateView show animation list or grid
class AnimateView extends StatelessWidget {
  /// AnimateView show animation list or grid
  /// ```dart
  /// AnimateView<int>(items: gridItems)
  /// ```
  const AnimateView({
    required this.animateViewProvider,
    required this.itemBuilder,
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    this.controller,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    Key? key,
  }) : super(key: key);

  /// animateViewProvider is the provider of the animate view
  final AnimateViewProvider animateViewProvider;

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

  @override
  Widget build(BuildContext context) {
    return AnimateGrid(
      controller: controller,
      shrinkWrap: shrinkWrap,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
      key: animateViewProvider._gridKey,
      crossAxisCount: crossAxisCount,
      initialItemCount: animateViewProvider._length,
      itemBuilder: (context, index, animation) {
        Widget widget = itemBuilder(index);
        return _slideIt(widget, animation);
      },
    );
  }
}

/// AnimateShiftView show shift animation list or grid
class AnimateShiftView extends StatelessWidget {
  const AnimateShiftView({
    required this.animateViewProvider,
    required this.itemBuilder,
    this.crossAxisCount = 1,
    this.shrinkWrap = false,
    this.controller,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1,
    Key? key,
  }) : super(key: key);

  /// animateViewProvider is the provider of the animate view
  final AnimateViewProvider animateViewProvider;

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

  @override
  Widget build(BuildContext context) {
    return Shifter(
      reverse: animateViewProvider._shifterReverse,
      vertical: animateViewProvider._shifterVertical,
      newChildKey: animateViewProvider._gridKey,
      child: AnimateGrid(
        controller: controller,
        shrinkWrap: shrinkWrap,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
        key: animateViewProvider._gridKey,
        crossAxisCount: crossAxisCount,
        initialItemCount: animateViewProvider._length,
        itemBuilder: (context, index, animation) {
          Widget widget = itemBuilder(index);
          return _slideIt(widget, animation);
        },
      ),
    );
  }
}
