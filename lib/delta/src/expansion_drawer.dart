import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _ExpansionDrawerProvider with ChangeNotifier {
  _ExpansionDrawerProvider(this._expanded);

  /// expanded is true if the panel is expanded
  bool _expanded;

  /// expanded is true if the panel is expanded
  set expanded(bool value) {
    _expanded = value;
    notifyListeners();
  }
}

/// ExpansionDrawer is a widget that expand/collapse when user click on it
class ExpansionDrawer<T> extends StatelessWidget {
  /// ```dart
  const ExpansionDrawer({
    required this.child,
    this.initiallyExpanded = false,
    this.expandedHeight = 100,
    this.collapsedHeight = 0,
    this.iconColor,
    this.iconBackgroundColor,
    super.key,
  });

  /// child is the widget in panel
  final Widget child;

  /// initiallyExpanded is true if the panel is expanded initially
  final bool initiallyExpanded;

  /// expandedHeight is the height of the panel when it is expanded
  final double expandedHeight;

  /// collapsedHeight is the height of the panel when it is collapsed
  final double collapsedHeight;

  /// iconColor is the color of the icon
  final Color? iconColor;

  /// iconBackgroundColor is the color of the icon background
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ExpansionDrawerProvider>(
        create: (context) => _ExpansionDrawerProvider(initiallyExpanded),
        child: Consumer<_ExpansionDrawerProvider>(
            builder: (context, expansionDrawerProvider, _) => Column(children: [
                  AnimatedContainer(
                    height: expansionDrawerProvider._expanded ? expandedHeight : collapsedHeight,
                    duration: const Duration(milliseconds: 250),
                    child: child,
                  ),
                  Container(
                    width: double.infinity,
                    color: iconBackgroundColor,
                    height: 26,
                    child: IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        expansionDrawerProvider.expanded = !expansionDrawerProvider._expanded;
                      },
                      icon: Icon(
                        color: iconColor,
                        expansionDrawerProvider._expanded
                            ? Icons.keyboard_double_arrow_up_outlined
                            : Icons.keyboard_double_arrow_down_outlined,
                      ),
                    ),
                  ),
                ])));
  }
}
