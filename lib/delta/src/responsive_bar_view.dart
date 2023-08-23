import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// _kMobileToolbarHeight is height of toolbar on mobile
const _kMobileToolbarHeight = 48.0;

/// _kDesktopToolbarHeight is height of toolbar on desktop
const _kDesktopToolbarHeight = 40.0;

/// _kDesktopToolbarTitleFontSize is font size of toolbar title on desktop
const _kDesktopToolbarTitleFontSize = 15.0;

/// _kDesktopToolbarIconSize is icon size of toolbar on desktop
const _kDesktopToolbarIconSize = 19.0;

/// _isMobile return true if is mobile
bool get _isMobile => delta.phoneScreen;

/// responsiveBar create sliver app bar for bar view
Widget responsiveBar(
  BuildContext context, {
  Widget? title,
  Color? backgroundColor,
  List<Widget>? actions,
  Widget? leading,
  double? elevation,
  bool primary = true,
  bool? centerTitle,
  bool pinned = true,
  bool floating = false,
  bool snap = false,
}) {
  final barHeight = _isMobile ? _kMobileToolbarHeight : _kDesktopToolbarHeight;
  final theme = Theme.of(context);
  final appBar = SliverAppBar(
    automaticallyImplyLeading: false,
    iconTheme: _isMobile
        ? null
        : theme.appBarTheme.iconTheme != null
            ? theme.appBarTheme.iconTheme!.copyWith(size: _kDesktopToolbarIconSize)
            : const IconThemeData(size: _kDesktopToolbarIconSize),
    title: title,
    centerTitle: centerTitle,
    toolbarHeight: barHeight,
    backgroundColor: backgroundColor,
    actions: actions,
    leading: leading ??
        (Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null),
    elevation: elevation,
    flexibleSpace: Container(),
    primary: primary,
    pinned: pinned,
    floating: floating,
    snap: snap,
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
      ),
    ),
    child: appBar,
  );
}

/// ResponsiveBarView show [BaseBar] in view
class ResponsiveBarView extends StatelessWidget {
  const ResponsiveBarView({
    required this.barBuilder,
    this.slivers,
    super.key,
  });

  /// bar is app bar
  final Widget Function() barBuilder;

  /// slivers is slivers
  final List<Widget>? slivers;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverLayoutBuilder(builder: (_, __) => barBuilder()),
        if (slivers != null) ...slivers!,
      ],
    );
  }
}

/// ResponsiveAppBar is app bar that support big and small screen
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ResponsiveAppBar({
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
      iconTheme: theme.appBarTheme.iconTheme != null
          ? theme.appBarTheme.iconTheme!.copyWith(size: _kDesktopToolbarIconSize)
          : const IconThemeData(size: _kDesktopToolbarIconSize),
      automaticallyImplyLeading: false,
      title: title,
      centerTitle: centerTitle,
      toolbarHeight: preferredSize.height,
      backgroundColor: backgroundColor,
      actions: actions,
      leading: leading ??
          (Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      elevation: elevation,
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
        ),
      ),
      child: appBar,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_isMobile ? _kMobileToolbarHeight : _kDesktopToolbarHeight);
}
