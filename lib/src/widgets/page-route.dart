import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// _testMode true should return success, false return error, otherwise behave normal
///
int _testMode = 0;

// testModeAlwaySuccess will let every function success
//
void testModeAlwaySuccess() {
  _testMode = 1;
}

// testModeAlwaySuccess will let every function fail
//
void testModeAlwayFail() {
  _testMode = -1;
}

// TestModeBackNormal stop test mode and back to normal
//
void testModeBackNormal() {
  _testMode = 0;
}

/// safeTestMaterialRoute return no animation route when testing
///
Route safeTestMaterialRoute(Widget widget) {
  if (!kReleaseMode && _testMode != 0) {
    return NoAnimRouteBuilder(widget);
  }
  return MaterialPageRoute(
    builder: (ctx) => widget,
  );
}

class NoAnimRouteBuilder extends PageRouteBuilder {
  final Widget page;

  NoAnimRouteBuilder(this.page)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 0),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child);
}

class FadeRouteBuilder extends PageRouteBuilder {
  final Widget page;

  FadeRouteBuilder(this.page)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
                  opacity: Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  )),
                  child: child,
                ));
}

class SlideTopRouteBuilder extends PageRouteBuilder {
  final Widget page;

  SlideTopRouteBuilder(this.page)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: Duration(milliseconds: 800),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                  position: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                      .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                  child: child,
                ));
}

class SizeRoute extends PageRouteBuilder {
  final Widget page;

  SizeRoute(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
//                Align(
//                  child: SizeTransition(child: child, sizeFactor: animation),
//                ),
              ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          ),
        );
}
