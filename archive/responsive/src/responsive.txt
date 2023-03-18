import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

/// DesignBuilder return widget for the design
typedef DesignBuilder = Widget Function();

/// return screen size on phone/tablet or windows size on desktop
Size get screenSize => window.physicalSize / window.devicePixelRatio;

/// phoneScreenMax is max width for phone screen
const phoneScreenMax = 600.0;

/// bigScreenDesignMin is min width to use big screen design
const bigScreenMin = 1100.0;

/// space is proper space for phone screen and bigger screen
double get space => phoneScreen ? 10 : 20;

/// phoneScreen return true if phone screen
bool get phoneScreen => screenSize.width < phoneScreenMax;

/// notPhoneScreen return true if not phone screen
bool get notPhoneScreen => !phoneScreen;

/// bigScreen return true if is beg screen
bool get bigScreen => screenSize.width > bigScreenMin;

/// notBigScreen return true if not big screen
bool get notBigScreen => !bigScreen;

/// isPhoneScreen return true if phone screen
bool isPhoneScreen(double width) => width < phoneScreenMax;

/// isNotPhoneScreen return true if not phone screen
bool isNotPhoneScreen(double width) => !isPhoneScreen(width);

/// isBigScreen return true if is beg screen
bool isBigScreen(double width) => width > bigScreenMin;

/// isNotBigScreen return true if not big screen
bool isNotBigScreen(double width) => !isBigScreen(width);

class Responsive extends StatelessWidget {
  /// Responsive help choose device proper layout widget
  ///
  ///     Responsive(phone:..., notPhone:...)
  ///
  const Responsive({
    required this.phoneScreen,
    this.notPhoneScreen,
    this.bigScreen,
    Key? key,
  }) : super(key: key);

  /// phoneScreen is widget for phone screen
  final DesignBuilder phoneScreen;

  /// notPhoneScreen is widget for not phone screen
  final DesignBuilder? notPhoneScreen;

  /// bigScreen is widget for big screen
  final DesignBuilder? bigScreen;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          (bigScreen != null && isBigScreen(constraints.maxWidth))
              ? bigScreen!()
              : isPhoneScreen(constraints.maxWidth)
                  ? phoneScreen()
                  : notPhoneScreen == null
                      ? phoneScreen()
                      : notPhoneScreen!());
}
