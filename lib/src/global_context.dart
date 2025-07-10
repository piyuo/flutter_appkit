// ===============================================
// Module: global_context_support.dart
// Description: Provides global access to BuildContext for dialogs, overlays, and localization
//
// Key Components:
//   - globalContext getter: Main API for accessing global context
//   - GlobalContext: Public wrapper widget
//   - _GlobalContext: Internal stateful implementation
//   - _GlobalContextState: State management and Navigator finding
//   - Helper functions: Initialization tracking and overlay access
//
// Usage:
//   1. Wrap your app: GlobalContext(child: MaterialApp(...))
//   2. Access globally: globalContext (from anywhere in your code)
//   3. Use for: Dialogs, overlays, localization, navigation
// ===============================================

import 'package:flutter/material.dart';

/// Global key to access the GlobalContext state from anywhere in the app
final GlobalKey<_GlobalContextState> _keyGlobalContextFinder = GlobalKey(debugLabel: 'global_context_support');

/// Provides global access to a BuildContext for use throughout the application.
///
/// This is useful for:
/// - Showing dialogs from non-widget code
/// - Accessing localization from services or utilities
/// - Displaying overlays or snackbars from business logic
///
/// Throws assertion errors in debug mode if GlobalContext is not properly initialized.
///
/// Example:
/// ```dart
/// // Show a dialog from anywhere
/// showDialog(
///   context: globalContext,
///   builder: (context) => AlertDialog(title: Text('Global Dialog')),
/// );
/// ```
BuildContext get globalContext {
  assert(
    _debugInitialized,
    'Global Context Support Not Initialized ! \n'
    'ensure your app wrapped widget GlobalContext()',
  );
  final state = _keyGlobalContextFinder.currentState;
  assert(() {
    if (state == null) {
      throw FlutterError('''we can not find GlobalContextState in your app.

         do you declare GlobalContext you app widget tree like this?

         GlobalContext(
           child: MaterialApp(
             home: HomePage(),
           ),
         )

      ''');
    }
    return true;
  }());
  return state!.context;
}

/// Flag to track if GlobalContext has been initialized
bool _debugInitialized = false;

/// A widget that provides global access to BuildContext throughout the application.
///
/// This widget should wrap your root application widget (typically MaterialApp or CupertinoApp).
/// It enables the [globalContext] getter to work from anywhere in your app.
///
/// Usage:
/// ```dart
/// void main() {
///   runApp(
///     GlobalContext(
///       child: MaterialApp(
///         home: MyHomePage(),
///       ),
///     ),
///   );
/// }
/// ```
///
/// **Important**: Only one GlobalContext should exist in your widget tree.
class GlobalContext extends StatelessWidget {
  final Widget child;

  const GlobalContext({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return _GlobalContext(child: child);
  }
}

class _GlobalContext extends StatefulWidget {
  final Widget child;

  _GlobalContext({required this.child}) : super(key: _keyGlobalContextFinder);

  @override
  StatefulElement createElement() {
    _debugInitialized = true;
    return super.createElement();
  }

  @override
  _GlobalContextState createState() => _GlobalContextState();
}

class _GlobalContextState extends State<_GlobalContext> {
  @override
  Widget build(BuildContext context) {
    assert(() {
      if (context.findAncestorWidgetOfExactType<_GlobalContext>() != null) {
        throw FlutterError('There is already an GlobalContext in the Widget tree.');
      }
      return true;
    }());
    return widget.child;
  }
}
