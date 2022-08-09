import 'package:flutter/material.dart';

/// FutureCallback
typedef FutureCallback<T> = Future<T> Function();

/// FutureContextCallback
typedef FutureContextCallback<T> = Future<T> Function(BuildContext context);

/// WidgetBuilder build widget
typedef WidgetBuilder<T> = Widget Function();

/// WidgetContextBuilder build widget with context
typedef WidgetContextBuilder<T> = Widget Function(BuildContext context);

/// WidgetContextWrapBuilder build widget with context and child
typedef WidgetContextWrapBuilder<T> = Widget Function(BuildContext context, Widget child);

/// WidgetContextIndexBuilder build widget with context and index
typedef WidgetContextIndexBuilder<T> = Widget Function(BuildContext context, int index);
