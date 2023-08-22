import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:universal_platform/universal_platform.dart';

/// _kMobileToolbarHeight is height of toolbar on mobile
const _kMobileToolbarHeight = 48.0;

/// _kDesktopToolbarHeight is height of toolbar on desktop
const _kDesktopToolbarHeight = 40.0;

/// _kDesktopToolbarTitleFontSize is font size of toolbar title on desktop
const _kDesktopToolbarTitleFontSize = 15.0;

/// _kDesktopToolbarIconSize is icon size of toolbar on desktop
const _kDesktopToolbarIconSize = 19.0;

/// _kMacOSLeading is width of leading on macos
const _kMacOSLeading = 168.0;

/// _isMobile return true if is mobile
bool get _isMobile => delta.phoneScreen && !UniversalPlatform.isMacOS;

/// BaseBar is app bar that support big and small screen
class BaseBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseBar({
    this.title,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.elevation,
    this.primary = true,
    this.centerTitle,
    super.key,
  });

  /// title is app bar title
  final Widget? title;

  /// backgroundColor is app bar background color
  final Color? backgroundColor;

  /// actions is app bar actions
  final List<Widget>? actions;

  /// leading is app bar leading
  final Widget? leading;

  /// elevation is app bar elevation
  final double? elevation;

  /// primary is app bar primary
  final bool primary;

  /// centerTitle is app bar center title
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) => createAppBar(context));
  }

  Widget createAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final appBar = AppBar(
      title: title,
      centerTitle: centerTitle,
      toolbarHeight: preferredSize.height,
      backgroundColor: backgroundColor,
      actions: actions,
      leading: leading,
      elevation: elevation,
      leadingWidth: UniversalPlatform.isMacOS ? _kMacOSLeading : null,
      flexibleSpace: Container(),
      primary: primary,
    );

    if (_isMobile) {
      return appBar;
    }
    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          titleTextStyle: theme.appBarTheme.titleTextStyle != null
              ? theme.appBarTheme.titleTextStyle!.copyWith(fontSize: _kDesktopToolbarTitleFontSize)
              : const TextStyle(fontSize: _kDesktopToolbarTitleFontSize),
          iconTheme: theme.appBarTheme.iconTheme != null
              ? theme.appBarTheme.iconTheme!.copyWith(size: _kDesktopToolbarIconSize)
              : const IconThemeData(size: _kDesktopToolbarIconSize),
        ),
      ),
      child: appBar,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_isMobile ? _kMobileToolbarHeight : _kDesktopToolbarHeight);
}

/// viewBar create app bar for view
Widget viewBar(
  BuildContext context, {
  Widget? title,
  Color? backgroundColor,
  List<Widget>? actions,
  Widget? leading,
  double? elevation,
  bool primary = true,
  bool? centerTitle,
  bool pinned = true,
  bool float = false,
}) {
  final barHeight = _isMobile ? _kMobileToolbarHeight : _kDesktopToolbarHeight;

  final theme = Theme.of(context);
  final appBar = SliverAppBar(
    title: title,
    centerTitle: centerTitle,
    toolbarHeight: barHeight,
    backgroundColor: backgroundColor,
    actions: actions,
    leading: leading,
    elevation: elevation,
    leadingWidth: UniversalPlatform.isMacOS ? _kMacOSLeading : null,
    flexibleSpace: Container(),
    primary: primary,
    pinned: pinned,
    floating: float,
  );

  if (_isMobile) {
    return appBar;
  }
  return Theme(
    data: theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        titleTextStyle: theme.appBarTheme.titleTextStyle != null
            ? theme.appBarTheme.titleTextStyle!.copyWith(fontSize: _kDesktopToolbarTitleFontSize)
            : TextStyle(fontSize: _kDesktopToolbarTitleFontSize, color: theme.colorScheme.onBackground),
        iconTheme: theme.appBarTheme.iconTheme != null
            ? theme.appBarTheme.iconTheme!.copyWith(size: _kDesktopToolbarIconSize)
            : const IconThemeData(size: _kDesktopToolbarIconSize),
      ),
    ),
    child: appBar,
  );
}

/// BarView show [BaseBar] in view
class BarView extends StatelessWidget {
  const BarView({
    required this.bar,
    this.slivers,
    this.child,
    super.key,
  });

  /// bar is app bar
  final Widget bar;

  /// slivers is slivers
  final List<Widget>? slivers;

  /// child is child
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        bar,
        if (slivers != null) ...slivers!,
        if (child != null) SliverToBoxAdapter(child: child!),
      ],
    );
  }
}
