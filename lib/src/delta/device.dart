import 'package:flutter/widgets.dart';

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

///  isMobileLayout return true if use mobile layout
bool isMobileLayout(double windowWidth) {
  return deviceLayout(windowWidth) == DeviceLayout.phone;
}

///  isTabletLayout return true if use mobile layout
bool isTabletLayout(double windowWidth) {
  return deviceLayout(windowWidth) == DeviceLayout.tablet;
}

///  isDesktopLayout return true if use mobile layout
bool isDesktopLayout(double windowWidth) {
  return deviceLayout(windowWidth) == DeviceLayout.desktop;
}

///  DeviceLayoutBuilder help choose device layout
class DeviceLayoutBuilder extends StatelessWidget {
  DeviceLayoutBuilder({
    required this.phone,
    required this.tablet,
    required this.desktop,
  });

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
  DeviceOrientationBuilder({
    required this.landscape,
    required this.portrait,
  });

  final WidgetBuilder landscape;

  final WidgetBuilder portrait;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      if (isMobileLayout(constraints.maxWidth)) {
        return portrait(context);
      }
      return landscape(context);
    });
  }
}
