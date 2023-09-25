import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:provider/provider.dart';
import 'apollo.dart';
import 'session_provider.dart';

/// kBarHeightDesktop is height of toolbar
const kBarHeightDesktop = 36.0;

/// kLogoSizeDesktop is logo size on desktop
const kLogoSizeDesktop = 22.0;

/// kBarHeightMobile is height of toolbar
const kBarHeightMobile = 40.0;

/// kLogoSizeMobile is logo size on mobile
const kLogoSizeMobile = 24.0;

/// barHeight is height of toolbar
get barHeight => delta.phoneScreen ? kBarHeightMobile : kBarHeightDesktop;

/// barIconSize is height of toolbar
get barIconSize => delta.phoneScreen ? kLogoSizeMobile : kLogoSizeDesktop;

/// Bar used to create app bar, we change it's height and font size and back button behavior
class Bar extends StatelessWidget implements PreferredSizeWidget {
  const Bar({
    required this.home,
    this.items = const [],
    this.actions = const [],
    this.primary = true,
    this.bottom,
    super.key,
  });

  /// home is home button widget
  final Widget home;

  /// items is menu item widgets on bar
  final List<Widget> items;

  /// actions is app bar actions
  final List<Widget> actions;

  /// primary is app bar primary
  final bool primary;

  /// bottom is app bar bottom
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(barHeight);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      buildMobile() {
        return AppBar(
          centerTitle: false,
          title: home,
          actions: [
            ...actions,
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
            const SizedBox(width: 10),
          ],
          primary: primary,
          bottom: bottom,
          elevation: 0,
        );
      }

      buildDesktop() {
        return AppBar(
          centerTitle: false,
          title: Row(
            children: [
              home,
              const SizedBox(width: 15),
              ...items,
            ],
          ),
          actions: [...actions, const SizedBox()], // SizedBox prevent show endDrawer button
          primary: primary,
          bottom: bottom,
          elevation: 0,
        );
      }

      return delta.phoneScreen ? buildMobile() : buildDesktop();
    });
  }
}

/// SliverBar is app bar in sliver
class SliverBar extends SliverLayoutBuilder {
  SliverBar({
    required Widget home,
    List<Widget> items = const [],
    List<Widget> actions = const [],
    bool primary = true,
    PreferredSizeWidget? bottom,
    super.key,
  }) : super(builder: (context, constraints) {
          final appBarTheme = Theme.of(context).appBarTheme;
          buildMobile() {
            return SliverAppBar(
              toolbarHeight: kBarHeightMobile,
              centerTitle: false,
              title: home,
              actions: [
                ...actions,
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
                const SizedBox(width: 10),
              ],
              primary: primary,
              bottom: bottom,
              elevation: 0,
              pinned: true,
              floating: true,
              snap: true,
            );
          }

          buildDesktop() {
            return SliverAppBar(
              toolbarHeight: kBarHeightDesktop,
              centerTitle: false,
              title: Row(
                children: [
                  home,
                  const SizedBox(width: 15),
                  ...items,
                ],
              ),
              //actions: actions,
              actions: [...actions, const SizedBox()], // SizedBox prevent show endDrawer button
              primary: primary,
              bottom: bottom,
              elevation: 0,
              pinned: true,
              floating: true,
              snap: true,
              backgroundColor: appBarTheme.backgroundColor,
            );
          }

          return delta.phoneScreen ? buildMobile() : buildDesktop();
        });
}

/// BarBackButton go back to previous page
class BarBackButton extends StatelessWidget {
  const BarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () => goBack(context),
    );
  }
}

/// BarLogoButton display go home button on bar
class BarLogoButton extends StatelessWidget {
  const BarLogoButton({
    required this.url,
    super.key,
  });

  /// url is logo image url
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: currentRoute(context) == '/' ? null : () => currentRoute(context),
      child: delta.WebImage(
        width: barIconSize,
        height: barIconSize,
        url: url,
      ),
    );
  }
}

/// BarItemButton display a menu item on bar
class BarItemButton extends StatelessWidget {
  const BarItemButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  /// text is item text
  final String text;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    return TextButton(
      style: TextButton.styleFrom().copyWith(
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: appBarTheme.titleTextStyle,
      ),
    );
  }
}

/// BarUserButton display user avatar and name on bar
class BarUserButton<T> extends StatelessWidget {
  const BarUserButton({
    required this.menuBuilder,
    required this.onMenuSelected,
    super.key,
  });

  /// menuBuilder show menu when user already signed in
  final List<PopupMenuEntry<T>> Function() menuBuilder;

  /// onMenuSelected is menu item selected callback
  final void Function(T)? onMenuSelected;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    return Consumer<SessionProvider>(builder: (context, sessionProvider, _) {
      final session = sessionProvider.session;
      final hasSession = session != null && (session.isValid || session.canRefresh);
      return PopupMenuButton<T>(
        tooltip: hasSession ? 'User menu' : 'Login / Create Account',
        onSelected: onMenuSelected,
        offset: const Offset(10, 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        itemBuilder: (BuildContext context) => hasSession ? menuBuilder() : [],
        child: TextButton.icon(
          style: TextButton.styleFrom().copyWith(
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
          icon: SizedBox(
              width: barIconSize,
              height: barIconSize,
              child: hasSession
                  ? delta.Avatar(
                      imageUrl: session[kSessionUserPhotoKey],
                      name: session[kSessionUserNameKey],
                    )
                  : Icon(Icons.account_circle, color: Theme.of(context).appBarTheme.foregroundColor)),
          label: Text(
            hasSession ? session[kSessionUserNameKey] : 'Login / Create Account',
            style: appBarTheme.titleTextStyle,
          ),
          onPressed: hasSession ? null : () => goTo(context, '/signin'),
        ),
      );
    });
  }
}

/// BarLanguageButton display a language menu on bar
class BarLanguageButton extends StatelessWidget {
  const BarLanguageButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  /// text is item text
  final String text;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final appBarTheme = Theme.of(context).appBarTheme;
    return TextButton(
      style: TextButton.styleFrom().copyWith(
        overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: appBarTheme.titleTextStyle,
      ),
    );
  }
}
