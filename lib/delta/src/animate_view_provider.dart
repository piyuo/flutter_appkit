import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animate_grid.dart';

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
    if (gridKey.currentState != null) {
      gridKey.currentState!.itemCount = _length;
    }
    if (notify) {
      notifyListeners();
    }
  }

  /// shifterReverse is true will reverse shifter animation
  bool shifterReverse = false;

  /// shifterVertical is true will use vertical shifter animation
  bool shifterVertical = false;

  /// gridKey is the key of the animated grid
  GlobalKey<AnimateGridState> gridKey = GlobalKey<AnimateGridState>(debugLabel: 'animateGridKey');

  /// refreshPageAnimation show refresh page animation
  void refreshPageAnimation(newPageLength) {
    shifterReverse = true;
    shifterVertical = true;
    gridKey = GlobalKey<AnimateGridState>();
    _length = newPageLength;
    notifyListeners();
  }

  /// nextPageAnimation show next page animation
  void nextPageAnimation(int nextPageLength) {
    shifterReverse = false;
    shifterVertical = false;
    gridKey = GlobalKey<AnimateGridState>();
    _length = nextPageLength;
    notifyListeners();
  }

  /// prevPageAnimation show prev page animation
  void prevPageAnimation(int prevPageLength) {
    shifterReverse = true;
    shifterVertical = false;
    gridKey = GlobalKey<AnimateGridState>();
    _length = prevPageLength;
    notifyListeners();
  }

  /// insertAnimation show insert animation
  void insertAnimation({int? index, int count = 1, Duration? duration}) {
    _length += count;
    if (gridKey.currentState != null) {
      for (int i = 0; i < count; i++) {
        gridKey.currentState!.insertItem(index ?? 0, duration: duration ?? animatedDuration);
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
    if (index != -1 && gridKey.currentState != null) {
      gridKey.currentState!.removeItem(
        index,
        (context, animation) => isSizeAnimation ? sizeIt(child, animation) : slideIt(child, animation),
        duration: duration ?? animatedDuration,
      );
      _length--;
    }
  }

  /// shakeAnimation show shake animation
  void shakeAnimation(int index) {
    if (index != -1 && gridKey.currentState != null) {
      gridKey.currentState!.shakeItem(
        index,
        (context, animation, child) => shakeIt(child, animation),
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

/// slideIt is slide animation
Widget slideIt(Widget child, animation) {
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

/// sizeIt is size animation
Widget sizeIt(Widget child, animation) {
  return SizeTransition(
    axis: Axis.vertical,
    sizeFactor: animation,
    child: child,
  );
}

/// shakeIt is shake animation
Widget shakeIt(Widget child, animation) {
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
