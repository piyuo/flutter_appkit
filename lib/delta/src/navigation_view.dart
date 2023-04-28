import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:split_view/split_view.dart';
import 'delta.dart';
import 'shifter.dart';

class NavigationViewProvider<T> with ChangeNotifier {
  NavigationViewProvider({
    required this.value,
  });

  /// value is current value that use in [NavigationView] builder
  T value;

  bool isSideView = true;

  void show(BuildContext context, T value) {
    final width = MediaQuery.of(context).size.width;
    if (isPhoneScreen(width)) {
      isSideView = false;
    } else {
      this.value = value;
      notifyListeners();
    }
    this.value = value;
    notifyListeners();
  }

  void useSideView() {
    isSideView = true;
    notifyListeners();
  }
}

class NavigationView<T> extends StatelessWidget {
  const NavigationView({
    required this.sideBuilder,
    required this.builder,
    Key? key,
  }) : super(key: key);

  final Widget Function(T) builder;

  final Widget Function(NavigationViewProvider navigationViewProvider) sideBuilder;

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationViewProvider<T>>(builder: (_, navigationViewProvider, __) {
      final colorScheme = Theme.of(context).colorScheme;
      final width = MediaQuery.of(context).size.width;
      return !isPhoneScreen(width)
          ? SplitView(
              gripSize: 5,
              gripColor: colorScheme.outlineVariant.withOpacity(.2),
              gripColorActive: colorScheme.outlineVariant.withOpacity(.5),
              controller: SplitViewController(
                weights: [0.4],
                limits: [WeightLimit(min: 0.25, max: 0.45)],
              ),
              viewMode: SplitViewMode.Horizontal,
              indicator: SplitIndicator(
                viewMode: SplitViewMode.Horizontal,
                color: colorScheme.outlineVariant.withOpacity(.9),
              ),
              activeIndicator: SplitIndicator(
                viewMode: SplitViewMode.Horizontal,
                isActive: true,
                color: colorScheme.outlineVariant,
              ),
              children: [
                sideBuilder(navigationViewProvider),
                builder(navigationViewProvider.value),
              ],
            )
          : Shifter(
              reverse: navigationViewProvider.isSideView,
              newChildKey: ValueKey(navigationViewProvider.isSideView),
              child: Container(
                key: ValueKey(navigationViewProvider.isSideView),
                constraints: const BoxConstraints.expand(),
                child: navigationViewProvider.isSideView
                    ? sideBuilder(navigationViewProvider)
                    : builder(navigationViewProvider.value),
              ),
            );
    });
  }
}
