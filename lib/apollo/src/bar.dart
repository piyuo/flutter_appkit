import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'apollo.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// _kToolbarHeight is height of toolbar
const _kToolbarHeight = 40.0;

/// _kToolbarTitleFontSize is font size of toolbar
const _kToolbarTitleFontSize = 15.0;

/// _kToolbarIconSize is icon size of toolbar
const _kToolbarIconSize = 19.0;

/// _kHomeButtonSize is home button size
const _kHomeButtonSize = 96.0;

/// _changeTheme change theme of app bar
Widget _changeTheme(BuildContext context, Widget child) {
  final theme = Theme.of(context);
  return Theme(
    data: theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        titleTextStyle: theme.appBarTheme.titleTextStyle != null
            ? theme.appBarTheme.titleTextStyle!.copyWith(fontSize: _kToolbarTitleFontSize)
            : TextStyle(fontSize: _kToolbarTitleFontSize, color: theme.colorScheme.onBackground),
      ),
    ),
    child: child,
  );
}

/// _changeLeading change back button on web mode
Widget? _changeLeading(BuildContext context, Widget? leading) {
  return kIsWeb ? leading ?? (Navigator.canPop(context) ? const BarBackButton() : null) : leading;
}

/// Bar used to create app bar, we change it's height and font size and back button behavior
class Bar extends StatelessWidget implements PreferredSizeWidget {
  const Bar({
    this.title,
    this.backgroundColor,
    this.actionsBuilder,
    this.leading,
    this.elevation,
    this.primary = true,
    this.centerTitle,
    this.leadingWidth,
    this.homeButton,
    this.homeButtonSize = _kHomeButtonSize,
    super.key,
  });

  /// title is app bar title
  final Widget? title;

  /// backgroundColor is app bar background color
  final Color? backgroundColor;

  /// actionsBuilder is build app bar actions
  final List<Widget> Function()? actionsBuilder;

  /// leading is app bar leading
  final Widget? leading;

  /// leadingWidth is app bar leading width
  final double? leadingWidth;

  /// elevation is app bar elevation
  final double? elevation;

  /// primary is app bar primary
  final bool primary;

  /// centerTitle is app bar center title
  final bool? centerTitle;

  /// homeButton is home button to go home page
  final Widget? homeButton;

  /// homeButtonSize is home button size
  final double homeButtonSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _changeTheme(
      context,
      LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        return AppBar(
          iconTheme: theme.appBarTheme.iconTheme != null
              ? theme.appBarTheme.iconTheme!.copyWith(size: _kToolbarIconSize)
              : const IconThemeData(size: _kToolbarIconSize),
          title: title,
          centerTitle: centerTitle ?? true,
          toolbarHeight: preferredSize.height,
          backgroundColor: backgroundColor,
          actions: actionsBuilder?.call(),
          leading: homeButton ?? _changeLeading(context, leading),
          leadingWidth: homeButton != null || kIsWeb
              ? delta.phoneScreen
                  ? null
                  : homeButtonSize
              : leadingWidth,
          elevation: elevation,
          primary: primary,
        );
      }),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_kToolbarHeight);
}

/// SliverBar is app bar in sliver
class SliverBar extends SliverLayoutBuilder {
  SliverBar({
    super.key,
    Widget? title,
    Color? backgroundColor,
    Widget? leading,
    double? elevation,
    bool primary = true,
    bool? centerTitle,
    bool pinned = true,
    bool floating = false,
    bool snap = false,
    double? leadingWidth,
    double spacing = 0,
    Widget? homeButton,
    double homeButtonSize = _kHomeButtonSize,
    List<Widget> Function()? actionsBuilder,
  }) : super(builder: (context, constraints) {
          final theme = Theme.of(context);
          return _changeTheme(
            context,
            SliverAppBar(
              titleSpacing: spacing,
              iconTheme: theme.appBarTheme.iconTheme != null
                  ? theme.appBarTheme.iconTheme!.copyWith(size: _kToolbarIconSize)
                  : const IconThemeData(size: _kToolbarIconSize),
              title: title,
              centerTitle: centerTitle ?? true, // default center title, cause mobile and desktop have different default
              toolbarHeight: _kToolbarHeight,
              backgroundColor: backgroundColor,
              actions: actionsBuilder?.call(),
              leading: homeButton ?? _changeLeading(context, leading),
              leadingWidth: homeButton != null
                  ? delta.phoneScreen
                      ? null
                      : homeButtonSize
                  : leadingWidth,
              elevation: elevation,
              primary: primary,
              pinned: pinned,
              floating: floating,
              snap: snap,
            ),
          );
        });
}

/// BarButton show icon on phone and icon with text on desktop, only icon on mobile
class BarButton extends StatelessWidget {
  const BarButton({
    this.onPressed,
    required this.icon,
    required this.text,
    super.key,
  });

  /// onRefresh call when user press button
  final VoidCallback? onPressed;

  /// size is icon size
  final Widget icon;

  /// text icon text
  final String text;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => IconButton(
            icon: delta.phoneScreen
                ? icon
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      const SizedBox(width: 5),
                      AutoSizeText(text, style: TextStyle(color: appBarTheme.foregroundColor)),
                    ],
                  ),
            onPressed: onPressed));
  }
}

/// BarHomeButton goto home page in web mode go to route '/' in app mode
class BarHomeButton extends StatelessWidget {
  const BarHomeButton({
    required this.icon,
    required this.text,
    super.key,
  });

  /// size is icon size
  final Widget icon;

  /// text icon text
  final String text;

  @override
  Widget build(BuildContext context) {
    return BarButton(
      icon: icon,
      text: text,
      onPressed: () => goHome(context),
    );
  }
}

/// BarBackButton go back to previous page
class BarBackButton extends StatelessWidget {
  const BarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BarButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      text: 'Back',
      onPressed: () => goBack(context),
    );
  }
}
