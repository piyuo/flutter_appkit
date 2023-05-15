import 'package:flutter/material.dart';
import 'package:libcli/general/general.dart' as general;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:split_view/split_view.dart' as sv;

/// SplitViewProvider is A provider that provides the [SplitView] with the ability to save and load side weight
class SplitViewProvider with ChangeNotifier, general.NeedInitializeMixin {
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
  general.DelayedRun delayRun = general.DelayedRun();

  /// set weights to [SplitViewProvider]
  void set(String viewKey, double value) {
    delayRun.run(() {
      final roundValue = double.parse((value).toStringAsFixed(2));
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
    required this.splitterViewProvider,
    this.builder,
    this.sideBuilder,
    this.isVertical = false,
    this.sideWeight = 0.4,
    this.sideWeightMax = 0.8,
    this.sideWeightMin = 0.2,
    required ValueKey<String> key,
  }) : super(key: key);

  /// sideBuilder return side widget, if null side will be hidden
  final Widget Function()? sideBuilder;

  /// builder is main content widget builder, if null main content will be hidden
  final Widget Function()? builder;

  /// isVertical is splitter orientation, default is horizontal
  final bool isVertical;

  /// splitterViewProvider is provider for [SplitView]
  final SplitViewProvider splitterViewProvider;

  /// sideWeight is side widget weight, default is 0.4
  final double sideWeight;

  /// sideWeight is side max widget weight, default is 0.8
  final double sideWeightMax;

  /// sideWeight is side min widget weight, default is 0.2
  final double sideWeightMin;

  @override
  Widget build(BuildContext context) {
    if (sideBuilder == null && builder == null) return const SizedBox();
    if (sideBuilder == null) return builder!();
    if (builder == null) return sideBuilder!();

    final valueKey = (key! as ValueKey<String>).value;
    final savedWeight = splitterViewProvider.get(valueKey);
    final colorScheme = Theme.of(context).colorScheme;
    return sv.SplitView(
      gripSize: 5,
      gripColor: colorScheme.outlineVariant.withOpacity(.2),
      gripColorActive: colorScheme.outlineVariant.withOpacity(.5),
      onWeightChanged: (weights) {
        if (weights[0] != null) splitterViewProvider.set(valueKey, weights[0]!);
      },
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
        if (sideBuilder != null) sideBuilder!(),
        if (builder != null) builder!(),
      ],
    );
  }
}
