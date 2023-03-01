import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// pushRoute push widget with new route, it will use NoAnimRouteBuilder in debug mode
Future<T?> pushRoute<T extends Object?>(BuildContext context, Widget widget) async {
  dynamic route;
  if (!kReleaseMode) {
    route = NoAnimRouteBuilder<T>(widget);
  } else {
    route = MaterialPageRoute<T>(
      builder: (ctx) => widget,
    );
  }
  return Navigator.of(context).push(route);
}

/// NoAnimRouteBuilder is a PageRouteBuilder with no animation
class NoAnimRouteBuilder<T extends Object?> extends PageRouteBuilder<T> {
  NoAnimRouteBuilder(this.widget)
      : super(
            opaque: false,
            pageBuilder: (context, animation, secondaryAnimation) => widget,
            transitionDuration: const Duration(milliseconds: 0),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => child);

  /// widget is the Widget to show;
  final Widget widget;
}

/// FadeRouteBuilder is a PageRouteBuilder with fade animation
class FadeRouteBuilder<T extends Object?> extends PageRouteBuilder<T> {
  FadeRouteBuilder(this.page)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
                  opacity: Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn,
                  )),
                  child: child,
                ));

  /// widget is the Widget to show;
  final Widget page;
}

/// SlideTopRouteBuilder is a PageRouteBuilder with slide top animation
class SlideTopRouteBuilder<T extends Object?> extends PageRouteBuilder<T> {
  SlideTopRouteBuilder(this.page)
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
                      .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                  child: child,
                ));

  /// widget is the Widget to show;
  final Widget page;
}

/// SizeRoute is a PageRouteBuilder with scale animation
class SizeRoute<T extends Object?> extends PageRouteBuilder<T> {
  SizeRoute(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => ScaleTransition(
            scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          ),
        );

  /// widget is the Widget to show;
  final Widget page;
}
