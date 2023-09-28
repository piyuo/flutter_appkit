import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// kFooterHeightDesktop is height of footer on desktop
const kFooterHeightDesktop = 46.0;

/// kFooterHeightMobile is height of footer on mobile
const kFooterHeightMobile = 68.0;

/// Footer used to create app footer
class Footer extends StatelessWidget implements PreferredSizeWidget {
  const Footer({
    this.copyRight,
    this.items = const [],
    this.actions = const [],
    this.backgroundColor,
    super.key,
  });

  /// copyRight is copy right widget
  final Widget? copyRight;

  /// items is menu item widgets on bar
  final List<Widget> items;

  /// actions is app bar actions
  final List<Widget> actions;

  /// backgroundColor is background color of footer
  final Color? backgroundColor;

  @override
  Size get preferredSize => Size.fromHeight(delta.phoneScreen ? kFooterHeightMobile : kFooterHeightDesktop);

  @override
  Widget build(BuildContext context) {
    List<Widget> itemsWithDivider = [];
    if (items.isNotEmpty) {
      for (Widget item in items) {
        itemsWithDivider.add(item);
        itemsWithDivider.add(const VerticalDivider());
      }
      itemsWithDivider.removeLast();
    } else {
      itemsWithDivider = items;
    }

    buildMobile() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (copyRight != null) Expanded(child: copyRight!),
              ...actions,
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: itemsWithDivider,
              )),
        ],
      );
    }

    buildDesktop() {
      return Row(
        children: [
          if (copyRight != null) Expanded(child: copyRight!),
          SizedBox(
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: itemsWithDivider,
              )),
          ...actions,
        ],
      );
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
          color: backgroundColor,
          height: delta.phoneScreen ? kFooterHeightMobile : kFooterHeightDesktop,
          child: delta.phoneScreen ? buildMobile() : buildDesktop());
    });
  }
}
