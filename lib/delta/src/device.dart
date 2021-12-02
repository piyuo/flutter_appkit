import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

Size get screenSize => window.physicalSize / window.devicePixelRatio;

enum DeviceLayout { phone, tablet, desktop }

enum DeviceOrientation { portrait, landscape }

const phoneWidth = 600.0;

const tabletWidth = 1200.0;

/// isDevicePhone return true if use phone layout
bool get isDevicePhone => isPhoneLayout(screenSize.width);

/// isDeviceTablet return true if use tablet layout
bool get isDeviceTablet => isTabletLayout(screenSize.width);

/// isDeviceDesktop return true if use desktop layout
bool get isDeviceDesktop => isDesktopLayout(screenSize.width);

/// deviceLayout return current suggest device layout base on window width
DeviceLayout deviceLayout(double windowWidth) {
  if (windowWidth < phoneWidth) {
    return DeviceLayout.phone;
  }
  if (windowWidth < tabletWidth) {
    return DeviceLayout.tablet;
  }
  return DeviceLayout.desktop;
}

/// isPhoneLayout return true if use phone layout
bool isPhoneLayout(double width) => deviceLayout(width) == DeviceLayout.phone;

/// isNotPhoneLayout return true if not use phone layout
bool isNotPhoneLayout(double width) => !isPhoneLayout(width);

/// isTabletLayout return true if use tablet layout
bool isTabletLayout(double width) => deviceLayout(width) == DeviceLayout.tablet;

/// isDesktopLayout return true if use desktop layout
bool isDesktopLayout(double width) => deviceLayout(width) == DeviceLayout.desktop;

/// DeviceLayoutWidget help choose device proper layout widget
class DeviceLayoutWidget extends StatelessWidget {
  const DeviceLayoutWidget({
    this.phone,
    this.notPhone,
    this.tablet,
    this.desktop,
    Key? key,
  }) : super(key: key);

  final WidgetBuilder? phone;

  final WidgetBuilder? notPhone;

  final WidgetBuilder? tablet;

  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      switch (deviceLayout(constraints.maxWidth)) {
        case DeviceLayout.phone:
          return phone != null ? phone!(context) : const SizedBox();
        case DeviceLayout.tablet:
          if (notPhone != null) {
            return notPhone!(context);
          }
          return tablet != null ? tablet!(context) : const SizedBox();
        default:
          if (notPhone != null) {
            return notPhone!(context);
          }
          return desktop != null ? desktop!(context) : const SizedBox();
      }
    });
  }
}

/// buildLayoutWidget help choose device layout builder to run
Widget? buildLayoutWidget(
  double width, {
  Function()? phone,
  Function()? notPhone,
  Function()? tablet,
  Function()? desktop,
}) {
  switch (deviceLayout(width)) {
    case DeviceLayout.phone:
      return phone != null ? phone() : null;
    case DeviceLayout.tablet:
      if (notPhone != null) {
        return notPhone();
      }
      return tablet != null ? tablet() : null;
    case DeviceLayout.desktop:
      if (notPhone != null) {
        return notPhone();
      }
      return desktop != null ? desktop() : null;
  }
}

/// DeviceOrientationWidget help choose orientation layout
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

/// buildOrientationWidget help choose device orientation builder to run
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
