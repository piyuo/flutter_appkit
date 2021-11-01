// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

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

Widget lineSpinIndicator({
  List<Color> colors = kDefaultRainbowColors,
}) =>
    LoadingIndicator(
      indicatorType: Indicator.lineSpinFadeLoader,
      colors: colors,
      strokeWidth: 4.0,
    );
