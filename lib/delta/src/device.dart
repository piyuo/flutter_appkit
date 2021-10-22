import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

Size get screenSize => window.physicalSize / window.devicePixelRatio;

enum DeviceLayout { phone, tablet, desktop }

enum DeviceOrientation { portrait, landscape }

///  deviceLayout return current suggest device layout base on window width
DeviceLayout deviceLayout(double windowWidth) {
  if (windowWidth < 600) {
    return DeviceLayout.phone;
  }
  if (windowWidth < 1200) {
    return DeviceLayout.tablet;
  }
  return DeviceLayout.desktop;
}

///  isPhone return true if use phone layout
bool get isPhone => isPhoneLayout(screenSize.width);

///  isPhoneLayout return true if use phone layout
bool isPhoneLayout(double windowWidth) {
  return deviceLayout(windowWidth) == DeviceLayout.phone;
}

///  isTablet return true if use tablet layout
bool get isTablet => isTabletLayout(screenSize.width);

///  isTabletLayout return true if use tablet layout
bool isTabletLayout(double windowWidth) {
  return deviceLayout(windowWidth) == DeviceLayout.tablet;
}

/// isDesktop return true if use desktop layout
bool get isDesktop => isDesktopLayout(screenSize.width);

///  isDesktopLayout return true if use desktop layout
bool isDesktopLayout(double windowWidth) {
  return deviceLayout(windowWidth) == DeviceLayout.desktop;
}

///  DeviceLayoutBuilder help choose device layout
class DeviceLayoutBuilder extends StatelessWidget {
  const DeviceLayoutBuilder({
    required this.phone,
    required this.tablet,
    required this.desktop,
    Key? key,
  }) : super(key: key);

  final WidgetBuilder phone;

  final WidgetBuilder tablet;

  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      switch (deviceLayout(constraints.maxWidth)) {
        case DeviceLayout.phone:
          return phone(context);
        case DeviceLayout.tablet:
          return tablet(context);
        default:
          return desktop(context);
      }
    });
  }
}

///  DeviceOrientationBuilder help choose orientation layout
class DeviceOrientationBuilder extends StatelessWidget {
  const DeviceOrientationBuilder({
    Key? key,
    required this.landscape,
    required this.portrait,
  }) : super(key: key);

  final WidgetBuilder landscape;

  final WidgetBuilder portrait;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isPhoneLayout(constraints.maxWidth)) {
        return portrait(context);
      }
      return landscape(context);
    });
  }
}
