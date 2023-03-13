import 'package:flutter/material.dart';

/// FutureCallback
typedef FutureCallback<T> = Future<T> Function();

/// FutureContextCallback
typedef FutureContextCallback<T> = Future<T> Function(BuildContext context);

/// WidgetBuilder build widget
typedef WidgetBuilder = Widget Function();

/// WidgetContextBuilder build widget with context
typedef WidgetContextBuilder = Widget Function(BuildContext context);

/// WidgetContextWrapper wrap widget with context and child
typedef WidgetContextWrapper = Widget Function(BuildContext context, Widget child);

/// WidgetContextIndexBuilder build widget with context and index
typedef WidgetContextIndexBuilder = Widget Function(BuildContext context, int index);
