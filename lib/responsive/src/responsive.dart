import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

/// DesignBuilder return widget for the design
typedef DesignBuilder = Widget Function();

/// return screen size on phone/tablet or windows size on desktop
Size get screenSize => window.physicalSize / window.devicePixelRatio;

/// phoneDesignMax is phone design max width
const phoneDesignMax = 600.0;

/// isPhoneDesign return true if use phone design, this function use global screen size
bool get isPhoneDesign => screenSize.width < phoneDesignMax;

/// isNotPhoneDesign return true if not use phone design, this function use global screen size
bool get isNotPhoneDesign => !isPhoneDesign;

class Responsive extends StatelessWidget {
  /// Responsive help choose device proper layout widget
  ///
  ///     Responsive(phone:..., notPhone:...)
  ///
  const Responsive({
    required this.phone,
    required this.notPhone,
    Key? key,
  }) : super(key: key);

  /// phone is widget for phone design
  final DesignBuilder phone;

  /// notPhone is widget for not phone design
  final DesignBuilder notPhone;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) =>
          constraints.maxWidth < phoneDesignMax ? phone() : notPhone());
}
