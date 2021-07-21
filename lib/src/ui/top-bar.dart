import 'package:flutter/material.dart';
import 'package:libcli/custom-icons.dart';

class TopBar extends StatelessWidget with PreferredSizeWidget {
  TopBar({
    this.titleSpacing,
    this.title,
    this.elevation,
  });

  final Widget? title;

  final double? titleSpacing;

  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      leading: _buildLeadingWidget(context),
      titleSpacing: titleSpacing,
      title: title,
      elevation: elevation,
    );
  }

  Widget _buildLeadingWidget(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);
    final parentRoute = ModalRoute.of(context);

    final bool canPop = ModalRoute.of(context)?.canPop ?? false;
    final bool hasDrawer = scaffold.hasDrawer;
    final bool useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget? leading = null;
    if (hasDrawer) {
      leading = IconButton(
        icon: const Icon(CustomIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    } else {
      if (canPop) {
        if (useCloseButton) {
          leading = IconButton(
              color: Theme.of(context).colorScheme.onBackground,
              icon: Icon(CustomIcons.close),
              onPressed: () => Navigator.of(context).maybePop());
        } else {
          leading = IconButton(
            padding: EdgeInsets.all(0),
            icon: Icon(CustomIcons.arrowBackIosNew),
            onPressed: Navigator.of(context).pop,
          );
        }
      }
    }

    return leading!;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
