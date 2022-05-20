import 'package:flutter/material.dart';

/// FutureCallback
typedef FutureCallback<T> = Future<T> Function();

/// FutureContextCallback
typedef FutureContextCallback<T> = Future<T> Function(BuildContext context);
