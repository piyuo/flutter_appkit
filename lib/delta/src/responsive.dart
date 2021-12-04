import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

/// DesignBuilder return widget for the design
typedef DesignBuilder = Widget? Function();

/// return screen size on phone/tablet or windows size on desktop
Size get screenSize => window.physicalSize / window.devicePixelRatio;

/// phoneDesignMax is phone design max width
const phoneDesignMax = 600.0;

/// tabletDesignMax is tablet design max width
const tabletDesignMax = 1200.0;

/// Design for responsive design
enum Design { phone, tablet, desktop }

/// currentDesign return current design
Design get currentDesign {
  if (screenSize.width < phoneDesignMax) {
    return Design.phone;
  }
  if (screenSize.width < tabletDesignMax) {
    return Design.tablet;
  }
  return Design.desktop;
}

/// isPhoneDesign return true if use phone design
bool get isPhoneDesign => currentDesign == Design.phone;

/// isNotPhoneDesign return true if not use phone design
bool get isNotPhoneDesign => currentDesign != Design.phone;

/// isTabletDesign return true if use tablet design
bool get isTabletDesign => currentDesign == Design.tablet;

/// isDesktopDesign return true if use desktop design
bool get isDesktopDesign => currentDesign == Design.desktop;

/// Responsive help choose device proper layout widget
///
///     LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints)=>DeviceLayoutWidget(constraints.maxWidth, phone:...)
///
class Responsive extends StatelessWidget {
  const Responsive({
    this.phone,
    this.notPhone,
    this.tablet,
    this.desktop,
    Key? key,
  }) : super(key: key);

  final DesignBuilder? phone;

  final DesignBuilder? notPhone;

  final DesignBuilder? tablet;

  final DesignBuilder? desktop;

  @override
  Widget build(BuildContext context) =>
      responsive(
        phone: phone,
        notPhone: notPhone,
        tablet: tablet,
        desktop: desktop,
      ) ??
      const SizedBox();
}

/// responsive help choose device layout builder to run
Widget? responsive({
  DesignBuilder? phone,
  DesignBuilder? notPhone,
  DesignBuilder? tablet,
  DesignBuilder? desktop,
}) {
  if (phone != null && currentDesign == Design.phone) {
    return phone.call();
  }
  if (tablet != null && currentDesign == Design.tablet) {
    return tablet.call();
  }
  if (desktop != null && currentDesign == Design.desktop) {
    return desktop.call();
  }
  if (notPhone != null && currentDesign != Design.phone) {
    return notPhone.call();
  }
  return null;
}
