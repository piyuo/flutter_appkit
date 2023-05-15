import 'package:flutter/material.dart';
import 'package:libcli/general/general.dart' as general;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:split_view/split_view.dart';

/// SplitterViewProvider is A provider that provides the [SplitterView] with the ability to save and load side weight
class SplitterViewProvider with ChangeNotifier, general.NeedInitializeMixin {
  SplitterViewProvider({
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

  /// set weights to [SplitterViewProvider]
  void set(String viewKey, double value) {
    delayRun.run(() {
      final roundValue = double.parse((value).toStringAsFixed(2));
      weights[viewKey] = roundValue;
      preferences.setMap(key, weights);
    });
  }

  /// get weights from [SplitterViewProvider]
  double? get(String key) => weights[key];
}

class SplitterView extends StatelessWidget {
  const SplitterView({
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

  /// splitterViewProvider is provider for [SplitterView]
  final SplitterViewProvider splitterViewProvider;

  /// sideWeight is side widget weight, default is 0.4
  final double sideWeight;

  /// sideWeight is side max widget weight, default is 0.8
  final double sideWeightMax;

  /// sideWeight is side min widget weight, default is 0.2
  final double sideWeightMin;

  @override
  Widget build(BuildContext context) {
    final valueKey = (key! as ValueKey<String>).value;
    final savedWeight = splitterViewProvider.get(valueKey);
    final colorScheme = Theme.of(context).colorScheme;
    return SplitView(
      gripSize: 5,
      gripColor: colorScheme.outlineVariant.withOpacity(.2),
      gripColorActive: colorScheme.outlineVariant.withOpacity(.5),
      onWeightChanged: (weights) {
        if (weights[0] != null) splitterViewProvider.set(valueKey, weights[0]!);
      },
      controller: SplitViewController(
        weights: [savedWeight ?? sideWeight],
        limits: [WeightLimit(min: sideWeightMin, max: sideWeightMax)],
      ),
      viewMode: isVertical ? SplitViewMode.Vertical : SplitViewMode.Horizontal,
      indicator: SplitIndicator(
        viewMode: isVertical ? SplitViewMode.Vertical : SplitViewMode.Horizontal,
        color: colorScheme.outlineVariant.withOpacity(.9),
      ),
      activeIndicator: SplitIndicator(
        viewMode: isVertical ? SplitViewMode.Vertical : SplitViewMode.Horizontal,
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
