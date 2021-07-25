import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/custom-icons.dart';

class Bar extends StatelessWidget with PreferredSizeWidget {
  Bar({
    this.titleSpacing,
    this.title,
    this.elevation,
    this.centerTitle,
    this.backToRoot,
  });

  final Widget? title;

  final double? titleSpacing;

  final double? elevation;

  final bool? centerTitle;

  /// backToRoot is true will show back button to go back to /index.html in web mode
  final bool? backToRoot;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: kToolbarHeight,
      automaticallyImplyLeading: false,
      leading: _buildLeadingWidget(context),
      titleSpacing: titleSpacing,
      title: title,
      elevation: elevation,
      centerTitle: centerTitle,
    );
  }

  Widget? _buildLeadingWidget(BuildContext context) {
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
      } else if (kIsWeb && backToRoot == true) {
        leading = IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(CustomIcons.arrowBackIosNew),
          onPressed: () => Navigator.of(context).pushNamed('gotoRoot'),
        );
      }
    }
    return leading;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
