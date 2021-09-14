import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;

class Bar extends StatelessWidget with PreferredSizeWidget {
  Bar({
    Key? key,
    this.titleSpacing,
    this.title,
    this.elevation,
    this.centerTitle,
    this.backToRoot,
    this.backgroundColor,
    this.iconColor,
  }) : super(key: key);

  final Widget? title;

  final double? titleSpacing;

  final double? elevation;

  final bool? centerTitle;

  final Color? backgroundColor;

  final Color? iconColor;

  /// backToRoot is true will show back button to go back to /index.html in web mode
  final bool? backToRoot;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
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

    if (hasDrawer) {
      return IconButton(
        color: iconColor,
        icon: const Icon(delta.CustomIcons.menu),
        onPressed: Scaffold.of(context).openDrawer,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }
    if (canPop) {
      if (useCloseButton) {
        return IconButton(
            color: iconColor ?? Theme.of(context).colorScheme.onBackground,
            icon: const Icon(delta.CustomIcons.close),
            onPressed: () => Navigator.of(context).maybePop());
      }
      return IconButton(
        color: iconColor,
        padding: const EdgeInsets.all(0),
        icon: const Icon(delta.CustomIcons.arrowBackIosNew),
        onPressed: Navigator.of(context).pop,
      );
    } else if (kIsWeb && backToRoot == true) {
      return IconButton(
        color: iconColor,
        padding: const EdgeInsets.all(0),
        icon: const Icon(delta.CustomIcons.arrowBackIosNew),
        onPressed: () => Navigator.of(context).pushNamed('gotoRoot'),
      );
    }

    return null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
