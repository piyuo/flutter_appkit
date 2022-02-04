// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

const List<Color> kDefaultRainbowColors = [
  Colors.red,
  Colors.orange,
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
];

Widget ballPulseIndicator({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    LoadingIndicator(
      indicatorType: Indicator.ballPulse,
      colors: colors,
      strokeWidth: 4.0,
    );

Widget ballSyncIndicator({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    const LoadingIndicator(
      indicatorType: Indicator.ballPulseSync,
      colors: kDefaultRainbowColors,
      strokeWidth: 4.0,
    );

Widget ballScaleIndicator({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    LoadingIndicator(
      indicatorType: Indicator.ballScaleMultiple,
      colors: colors,
      strokeWidth: 4.0,
    );

Widget lineScaleIndicator({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    LoadingIndicator(
      indicatorType: Indicator.lineScalePulseOut,
      colors: colors,
      strokeWidth: 4.0,
    );

Widget ballSpinIndicator({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    LoadingIndicator(
      indicatorType: Indicator.ballSpinFadeLoader,
      colors: colors,
      strokeWidth: 4.0,
    );

Widget ballRotateChase({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    LoadingIndicator(
      indicatorType: Indicator.ballRotateChase,
      colors: colors,
      strokeWidth: 12.0,
    );

/// NoDataDisplay show a no data display on page
class NoDataDisplay extends StatelessWidget {
  const NoDataDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 250,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wb_cloudy_outlined,
              size: 54,
              color: Colors.grey,
            ),
            Text(context.i18n.noDataLabel,
                style: const TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
      );
}

/// LoadingDisplay show a loading display on page
class LoadingDisplay extends StatelessWidget {
  const LoadingDisplay({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 250,
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
                width: 100,
                height: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOut,
                  colors: kDefaultRainbowColors,
                  strokeWidth: 4.0,
                )),
            const SizedBox(height: 25),
            Text(context.i18n.loadingLabel,
                style: const TextStyle(
                  color: Colors.grey,
                )),
          ],
        ),
      );
}
