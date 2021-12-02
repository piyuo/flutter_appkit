import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

Size get screenSize => window.physicalSize / window.devicePixelRatio;

enum DeviceLayout { phone, tablet, desktop }

enum DeviceOrientation { portrait, landscape }

const phoneWidth = 600.0;

const tabletWidth = 1200.0;

///  deviceLayout return current suggest device layout base on window width
DeviceLayout deviceLayout(double windowWidth) {
  if (windowWidth < phoneWidth) {
    return DeviceLayout.phone;
  }
  if (windowWidth < tabletWidth) {
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
    this.phone,
    this.tablet,
    this.desktop,
    Key? key,
  }) : super(key: key);

  final WidgetBuilder? phone;

  final WidgetBuilder? tablet;

  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      switch (deviceLayout(constraints.maxWidth)) {
        case DeviceLayout.phone:
          return phone != null ? phone!(context) : const SizedBox();
        case DeviceLayout.tablet:
          return tablet != null ? tablet!(context) : const SizedBox();
        default:
          return desktop != null ? desktop!(context) : const SizedBox();
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
