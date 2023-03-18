import 'package:flutter/material.dart';

/// Wrapped is group of wrapped children
class Wrapped {
  Wrapped({
    required this.title,
    required this.children,
    this.childHeight = 120,
    this.childWidth = 320,
  });

  final double childHeight;

  final double childWidth;

  final Widget title;

  final List<Widget> children;

  int rowCount(double width) {
    int childRowCount = width ~/ childWidth;
    int childRowTotal = (children.length / childRowCount).ceil();
    return childRowTotal + 1; // 1 is title
  }

  Widget row(BuildContext context, double width, int i) {
    if (i == 0) {
      return title;
    }

    var childRowCount = width ~/ childWidth;
    var extraSpace = width % childWidth / childRowCount;
    var newWidth = childWidth + extraSpace;

    List<Widget> list = <Widget>[];
    for (int index = 0; index < childRowCount; index++) {
      var base = childRowCount * (i - 1);
      if (base + index >= children.length) {
        break;
      }
      var child = children[base + index];
      list.add(SizedBox(width: newWidth, height: childHeight, child: child));
    }

    return Row(
      children: list,
    );
  }
}

/// WrappedListView is wrap items in list view
class WrappedListView extends StatelessWidget {
  const WrappedListView({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Wrapped> children;

  int _itemCount(double width) {
    int count = 0;
    for (var wrapped in children) {
      count += wrapped.rowCount(width);
    }
    return count;
  }

  Widget _item(BuildContext context, double width, int i) {
    int base = 0;
    for (var wrapped in children) {
      var count = wrapped.rowCount(width);
      if (i >= base && i < base + count) {
        return wrapped.row(context, width, i - base);
      }
      base += count;
    }
    assert(false, 'item not found. maybe wrong item count');
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => ListView.builder(
              itemCount: _itemCount(constraints.maxWidth),
              shrinkWrap: true,
              itemBuilder: (context, i) => _item(context, constraints.maxWidth, i),
            ));
  }
}
