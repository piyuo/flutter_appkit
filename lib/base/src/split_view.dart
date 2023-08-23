import 'package:flutter/material.dart';
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:split_view/split_view.dart' as sv;

/// SplitViewProvider is A provider that provides the [SplitView] with the ability to save and load side weight
class SplitViewProvider with ChangeNotifier, utils.InitOnceMixin {
  SplitViewProvider({
    required this.key,
  }) {
    initFuture = () async {
      final map = await preferences.getMap(key);
      if (map != null) {
        weights = map;
      }
    };
  }

  /// key in preferences
  final String key;

  /// _weights is a map that contains the side weight
  Map<String, dynamic> weights = {};

  /// delayRun used to delay set weights
  utils.DelayedRun delayRun = utils.DelayedRun();

  /// set weights to [SplitViewProvider]
  void set(String viewKey, double weight, double width) {
    delayRun.run(() {
      debugPrint(width.toString());
      final roundValue = double.parse((weight).toStringAsFixed(2));
      weights[viewKey] = roundValue;
      preferences.setMap(key, weights);
    });
  }

  /// get weights from [SplitViewProvider]
  double? get(String key) => weights[key];
}

/// SplitView is a widget that contains a side widget and a main widget
class SplitView extends StatelessWidget {
  const SplitView({
    required this.splitViewProvider,
    this.builder,
    this.barBuilder,
    this.sideBuilder,
    this.sideBarBuilder,
    this.isVertical = false,
    this.sideWeight = 0.4,
    this.sideWeightMax = 0.8,
    this.sideWeightMin = 0.2,
    this.newNavigatorKey,
    super.key,
  });

  /// sideBuilder return side widget, if null side will be hidden
  final utils.WidgetContextBuilder? sideBuilder;

  /// sideBar is a widget that will be shown on the left side of the side widget
  final utils.WidgetContextBuilder? sideBarBuilder;

  /// bar is a widget that will be shown on the right side of the side widget
  final utils.WidgetContextBuilder? barBuilder;

  /// builder is main content widget builder, if null main content will be hidden
  final utils.WidgetContextBuilder? builder;

  /// isVertical is split view orientation, default is horizontal
  final bool isVertical;

  /// SplitViewProvider is provider for [SplitView]
  final SplitViewProvider splitViewProvider;

  /// sideWeight is side widget weight, default is 0.4
  final double sideWeight;

  /// sideWeight is side max widget weight, default is 0.8
  final double sideWeightMax;

  /// sideWeight is side min widget weight, default is 0.2
  final double sideWeightMin;

  /// newNavigatorKey is not null will use navigator to navigate to the main content, default is true
  final GlobalKey? newNavigatorKey;

  @override
  Widget build(BuildContext context) {
    buildSide() {
      return sideBarBuilder != null
          ? Column(children: [sideBarBuilder!(context), Expanded(child: sideBuilder!(context))])
          : sideBuilder!(context);
    }

    buildMain() {
      mainContent(ctx) =>
          barBuilder != null ? Column(children: [barBuilder!(ctx), Expanded(child: builder!(ctx))]) : builder!(ctx);

      if (newNavigatorKey != null) {
        return Navigator(
          key: newNavigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute(builder: (ctx) => mainContent(ctx)),
        );
      }
      return mainContent(context);
    }

    if (sideBuilder == null && builder == null) return const SizedBox();
    if (sideBuilder == null) return buildMain();
    if (builder == null) return buildSide();

    final valueKey = (key! as ValueKey<String>).value;
    final savedWeight = splitViewProvider.get(valueKey);
    final colorScheme = Theme.of(context).colorScheme;

    return sv.SplitView(
      gripSize: 5,
      gripColor: colorScheme.outlineVariant.withOpacity(.2),
      gripColorActive: colorScheme.outlineVariant.withOpacity(.5),
      controller: sv.SplitViewController(
        weights: [savedWeight ?? sideWeight],
        limits: [sv.WeightLimit(min: sideWeightMin, max: sideWeightMax)],
      ),
      viewMode: isVertical ? sv.SplitViewMode.Vertical : sv.SplitViewMode.Horizontal,
      indicator: sv.SplitIndicator(
        viewMode: isVertical ? sv.SplitViewMode.Vertical : sv.SplitViewMode.Horizontal,
        color: colorScheme.outlineVariant.withOpacity(.9),
      ),
      activeIndicator: sv.SplitIndicator(
        viewMode: isVertical ? sv.SplitViewMode.Vertical : sv.SplitViewMode.Horizontal,
        isActive: true,
        color: colorScheme.outlineVariant,
      ),
      children: [
        if (sideBuilder != null) buildSide(),
        if (builder != null) buildMain(),
      ],
    );
  }
}
