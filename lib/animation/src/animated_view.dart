import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animated_grid.dart';
import 'shifter.dart';

/// itemBuilder is item builder for list or grid
typedef ItemBuilder<T> = Widget Function(T item);

/// AnimatedViewProvider control view's animation
/// ```dart
/// return ChangeNotifierProvider<AnimatedViewProvider<int>>(
/// create: (context) => AnimatedViewProvider<int>(
///   listBuilder: (int item) {
///     ...
///   },
///   gridBuilder: (int item) {
///     ...
///   },
/// ),
/// child:
/// ```
class AnimatedViewProvider<T> with ChangeNotifier {
  /// AnimatedViewProvider control view's animation
  /// ```dart
  /// return ChangeNotifierProvider<AnimatedViewProvider<int>>(
  /// create: (context) => AnimatedViewProvider<int>(
  ///   listBuilder: (int item) {
  ///     ...
  ///   },
  ///   gridBuilder: (int item) {
  ///     ...
  ///   },
  /// ),
  /// child:
  /// ```
  AnimatedViewProvider({
    required this.listBuilder,
    required this.gridBuilder,
    this.crossAxisCount = 1,
  });

  /// listBuilder is the builder for list view
  final ItemBuilder<T> listBuilder;

  /// gridBuilder is the builder for grid view
  final ItemBuilder<T> gridBuilder;

  /// crossAxisCount is 1 will show list view, others is grid view
  int crossAxisCount;

  /// setCrossAxisCount set current crossAxisCount
  /// ```dart
  /// setCrossAxisCount(1);
  /// ```
  void setCrossAxisCount(int value) {
    if (value != crossAxisCount) {
      crossAxisCount = value;
      notifyListeners();
    }
  }

  /// isListView return true if crossAxisCount is 1
  bool get isListView => crossAxisCount == 1;

  /// _shifterReverse is true will reverse shifter animation
  bool _shifterReverse = false;

  /// _gridKey is the key of the animated grid
  GlobalKey<AnimatedGridState> _gridKey = GlobalKey<AnimatedGridState>();

  /// _buildItem build for AnimatedView
  Widget _buildItem(List<T> items, int index, Animation<double> animation) {
    T item = items[index];
    return _slideIt(item, animation);
  }

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
  void removeAnimation(int index, T item) {
    if (index != -1) {
      _gridKey.currentState!.removeItem(
        index,
        (_, animation) => isListView ? _sizeIt(item, animation) : _slideIt(item, animation),
        duration: animatedDuration,
      );
    }
  }

  /// _slideIt is slide animation
  Widget _slideIt(T item, animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: const Offset(0, 0),
      ).animate(animation),
      child: SizeTransition(
        axis: Axis.vertical,
        sizeFactor: animation,
        child: isListView ? listBuilder(item) : gridBuilder(item),
      ),
    );
  }

  /// _slideIt is size animation
  Widget _sizeIt(T item, animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: isListView ? listBuilder(item) : gridBuilder(item),
    );
  }
}

/// AnimatedView show animation list or grid
/// ```dart
/// AnimatedView<int>(items: gridItems)
/// ```
class AnimatedView<T> extends StatelessWidget {
  /// AnimatedView show animation list or grid
  /// ```dart
  /// AnimatedView<int>(items: gridItems)
  /// ```
  const AnimatedView({
    required this.items,
    Key? key,
  }) : super(key: key);

  /// items is the list of items
  final List<T> items;

  @override
  Widget build(BuildContext context) {
    return Consumer<AnimatedViewProvider<T>>(
      builder: (context, provide, _) => Shifter(
        reverse: provide._shifterReverse,
        newChildKey: provide._gridKey,
        child: AnimatedGrid(
          key: provide._gridKey,
          crossAxisCount: provide.crossAxisCount,
          initialItemCount: items.length,
          itemBuilder: (context, index, animation) => provide._buildItem(items, index, animation),
        ),
      ),
    );
  }
}
