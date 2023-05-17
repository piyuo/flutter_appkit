import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;

/// Navigation used to configure items or destinations in the various navigation
/// mechanism. For [BottomNavigationBar], see [BottomNavigationBarItem]. For
/// [NavigationRail], see [NavigationRailDestination]. For [Drawer], see
/// [ListTile].
class Navigation {
  const Navigation({
    required this.title,
    required this.icon,
    this.badge,
    this.tooltip,
  });

  final String title;

  final IconData icon;

  final String? badge;

  final String? tooltip;
}

class NavigationScaffold extends StatelessWidget {
  const NavigationScaffold({
    required this.selectedIndex,
    required this.destinations,
    required this.onSelected,
    this.leadingInRail,
    this.trailingInRail,
    this.appBar,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.endDrawer,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.railWidth,
    Key? key,
  }) : super(key: key);

  /// See [Scaffold.appBar].
  final PreferredSizeWidget? appBar;

  /// See [Scaffold.body].
  final Widget body;

  /// See [Scaffold.floatingActionButton].
  final FloatingActionButton? floatingActionButton;

  /// See [Scaffold.floatingActionButtonLocation].
  ///
  /// Ignored if [fabInRail] is true.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// See [Scaffold.floatingActionButtonAnimator].
  ///
  /// Ignored if [fabInRail] is true.
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;

  /// See [Scaffold.persistentFooterButtons].
  final List<Widget>? persistentFooterButtons;

  /// See [Scaffold.endDrawer].
  final Widget? endDrawer;

  /// See [Scaffold.drawerScrimColor].
  final Color? drawerScrimColor;

  /// See [Scaffold.backgroundColor].
  final Color? backgroundColor;

  /// See [Scaffold.bottomSheet].
  final Widget? bottomSheet;

  /// See [Scaffold.resizeToAvoidBottomInset].
  final bool? resizeToAvoidBottomInset;

  /// See [Scaffold.primary].
  final bool primary;

  /// See [Scaffold.drawerDragStartBehavior].
  final DragStartBehavior drawerDragStartBehavior;

  /// See [Scaffold.extendBody].
  final bool extendBody;

  /// See [Scaffold.extendBodyBehindAppBar].
  final bool extendBodyBehindAppBar;

  /// See [Scaffold.drawerEdgeDragWidth].
  final double? drawerEdgeDragWidth;

  /// See [Scaffold.drawerEnableOpenDragGesture].
  final bool drawerEnableOpenDragGesture;

  /// See [Scaffold.endDrawerEnableOpenDragGesture].
  final bool endDrawerEnableOpenDragGesture;

  /// The index into [destinations] for the current selected
  /// [AdaptiveScaffoldDestination].
  final int selectedIndex;

  /// Defines the appearance of the items that are arrayed within the
  /// navigation.
  ///
  /// The value must be a list of two or more [Navigation]
  /// values.
  final List<Navigation> destinations;

  /// Called when one of the [destinations] is selected.
  ///
  /// The stateful widget that creates the adaptive scaffold needs to keep
  /// track of the index of the selected [AdaptiveScaffoldDestination] and call
  /// `setState` to rebuild the adaptive scaffold with the new [selectedIndex].
  final ValueChanged<int> onSelected;

  final Widget? leadingInRail;

  final Widget? trailingInRail;

  final double? railWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bigDisplay = delta.isBigScreen(screenWidth);
    final phoneDisplay = delta.isPhoneScreen(screenWidth);

    buildIcon(Navigation n) {
      return Tooltip(
          message: n.tooltip ?? n.title,
          child: delta.AnimatedBadge(
            label: n.badge,
            child: Icon(n.icon),
          ));
    }

    buildLabel(Navigation n) {
      return Tooltip(message: n.tooltip ?? n.title, child: Text(n.title));
    }

    return Scaffold(
      key: key,
      appBar: appBar,
      body: phoneDisplay
          ? body
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: bigDisplay ? railWidth : null,
                  child: NavigationRail(
                    leading: bigDisplay ? leadingInRail : null,
                    trailing: bigDisplay ? trailingInRail : null,
                    extended: bigDisplay,
                    labelType: bigDisplay ? NavigationRailLabelType.none : NavigationRailLabelType.all,
                    destinations: destinations
                        .map((n) => NavigationRailDestination(
                              icon: buildIcon(n),
                              label: buildLabel(n),
                            ))
                        .toList(),
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onSelected,
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                ),
                Expanded(
                  child: body,
                ),
              ],
            ),
      bottomNavigationBar: phoneDisplay
          ? BottomNavigationBar(
              items: destinations
                  .map((n) => BottomNavigationBarItem(
                        icon: buildIcon(n),
                        label: n.title,
                        tooltip: n.tooltip,
                      ))
                  .toList(),
              currentIndex: selectedIndex,
              onTap: onSelected,
              type: BottomNavigationBarType.fixed,
            )
          : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      endDrawer: endDrawer,
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: true,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
    );
  }
}
