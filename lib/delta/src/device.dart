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

///  DeviceLayoutWidget help choose device proper layout widget
class DeviceLayoutWidget extends StatelessWidget {
  const DeviceLayoutWidget({
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

///  buildLayoutWidget help choose device layout builder to run
Widget? buildLayoutWidget(
  double width, {
  Function()? phone,
  Function()? tablet,
  Function()? desktop,
}) {
  switch (deviceLayout(width)) {
    case DeviceLayout.phone:
      return phone != null ? phone() : null;
    case DeviceLayout.tablet:
      return tablet != null ? tablet() : null;
    case DeviceLayout.desktop:
      return desktop != null ? desktop() : null;
  }
}

///  DeviceOrientationWidget help choose orientation layout
class DeviceOrientationWidget extends StatelessWidget {
  const DeviceOrientationWidget({
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

///  buildOrientationWidget help choose device orientation builder to run
Widget? buildOrientationWidget(
  double width, {
  Function()? landscape,
  Function()? portrait,
}) {
  if (isPhoneLayout(width)) {
    return portrait != null ? portrait() : null;
  }
  return landscape != null ? landscape() : null;
}
