import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter/foundation.dart';

/// DesignBuilder return widget for the design
typedef DesignBuilder = Widget Function();

/// return screen size on phone/tablet or windows size on desktop
Size get screenSize =>
    WidgetsBinding.instance.platformDispatcher.views.first.physicalSize /
    WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;

/// phoneScreenMax is max width for phone screen
const phoneScreenMax = 600.0;

/// bigScreenDesignMin is min width to use big screen design
const bigScreenMin = 1134.0; // 1133 is ipad mini in landscape

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

/// DeltaBuildContext add color function to BuildContext
extension DeltaBuildContext on BuildContext {
  /// isDark return true if is dark theme, we
  /// ```dart
  /// context.isDark;
  /// ```
  bool get isDark => MediaQuery.of(this).platformBrightness == Brightness.dark;

// todo:need remove
/*

  /// themeColor return right color base on light theme or dark theme
  /// ```dart
  /// context.themeColor(light:Colors.blue,dark:Colors.red);
  /// ```
  Color themeColor({
    Color dark = Colors.white,
    Color light = Colors.black,
  }) =>
      isDark ? dark : light;

  /// invertColor return white on dark, black on light
  /// ```dart
  /// context.invertedColor;
  /// ```
  Color get invertedColor => isDark ? Colors.white : Colors.black;

  /// invertColor return white on light, black on dark
  /// ```dart
  /// context.sameColor;
  /// ```
  Color get sameColor => isDark ? Colors.black : Colors.white;
*/
  /// isTouchSupported is true if is on ios or android
  /// ```dart
  /// context.isTouchSupported;
  /// ```
  bool get isTouchSupported {
    return UniversalPlatform.isIOS || UniversalPlatform.isAndroid;
    //not working if theme is not initialize
    //var platform = Theme.of(this).platform;
    //return platform == TargetPlatform.iOS || platform == TargetPlatform.android;
  }

  /// isPreferMouse is true if os prefer mouse or touch pad
  /// ```dart
  /// context.isPreferMouse;
  /// ```
  bool get isPreferMouse {
    if (kIsWeb) {
      return true;
    }
    return !isTouchSupported;
  }
}

// mergeTextStyle takes in a TextStyle object, along with optional parameters for font size and color.
TextStyle mergeTextStyle(
  TextStyle? style, {
  double? fontSize,
  Color? color,
}) {
  return style != null
      ? style.copyWith(
          fontSize: fontSize ?? style.fontSize,
          color: color ?? style.color,
        )
      : TextStyle(
          color: color,
          fontSize: fontSize,
        );
}
