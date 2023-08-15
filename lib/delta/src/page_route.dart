import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/utils/utils.dart' as utils;

/// pushRoute push widget with new route, it will use NoAnimRouteBuilder in debug mode
Future<T?> pushRoute<T extends Object?>(
  BuildContext context,
  Widget widget, {
  bool replacement = false,
}) async {
  dynamic route;
  if (!kReleaseMode && testing.isTestMode) {
    route = NoAnimRouteBuilder<T>(() => widget);
  } else {
    route = MaterialPageRoute<T>(
      builder: (ctx) => widget,
    );
  }
  if (replacement) {
    return Navigator.of(context).pushReplacement(route);
  }
  return Navigator.of(context).push(route);
}

/// NoAnimRouteBuilder is a PageRouteBuilder with no animation
class NoAnimRouteBuilder<T extends Object?> extends PageRouteBuilder<T> {
  NoAnimRouteBuilder(this.builder)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => builder(),
            transitionDuration: const Duration(milliseconds: 0),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child);

  /// builder return Widget to show;
  final utils.WidgetBuilder builder;
}

/// FadeRouteBuilder is a PageRouteBuilder with fade animation
class FadeRouteBuilder<T extends Object?> extends PageRouteBuilder<T> {
  FadeRouteBuilder(this.builder)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => builder(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
                  opacity: Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  )),
                  child: child,
                ));

  /// builder return Widget to show;
  final utils.WidgetBuilder builder;
}

/// SlideTopRouteBuilder is a PageRouteBuilder with slide top animation
class SlideTopRouteBuilder<T extends Object?> extends PageRouteBuilder<T> {
  SlideTopRouteBuilder(this.builder)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => builder(),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
                      .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                  child: child,
                ));

  /// builder return Widget to show;
  final utils.WidgetBuilder builder;
}

/// SizeRoute is a PageRouteBuilder with scale animation
class SizeRoute<T extends Object?> extends PageRouteBuilder<T> {
  SizeRoute(this.builder)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          ),
        );

  /// builder return Widget to show;
  final utils.WidgetBuilder builder;
}
