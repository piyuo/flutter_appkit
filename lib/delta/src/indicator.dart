// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

List<Color> get kDefaultRainbowColors => [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

Widget ballPulseIndicator() => LoadingIndicator(
      indicatorType: Indicator.ballPulse,
      colors: kDefaultRainbowColors,
      strokeWidth: 4.0,
    );

Widget ballSyncIndicator() => LoadingIndicator(
      indicatorType: Indicator.ballPulseSync,
      colors: kDefaultRainbowColors,
      strokeWidth: 4.0,
    );

Widget ballScaleIndicator() => LoadingIndicator(
      indicatorType: Indicator.ballScaleMultiple,
      colors: [
        Colors.blue[300]!,
        Colors.blue,
        Colors.blue[800]!,
      ],
      strokeWidth: 4.0,
    );

Widget lineScaleIndicator() => LoadingIndicator(
      indicatorType: Indicator.lineScalePulseOut,
      colors: kDefaultRainbowColors,
      strokeWidth: 4.0,
    );

Widget lineSpinIndicator() => LoadingIndicator(
      indicatorType: Indicator.lineSpinFadeLoader,
      colors: kDefaultRainbowColors,
      strokeWidth: 4.0,
    );
