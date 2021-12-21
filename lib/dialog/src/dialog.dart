import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// DialogProvider for show dialog, must set navigatorKey and initToast to app
///
///      Provider(
///      create: (_) => DialogProvider(),
///      child: Consumer<DialogProvider>(
///        builder: (context, dialogProvider, _) => MaterialApp(
///         navigatorKey: dialogProvider.navigatorKey,
///         ...),
///      ),
///    )
class DialogProvider {
  DialogProvider() {
    _instance = this;
  }

  /// NavigatorKey used in rootContext
  ///
  final navigatorKey = GlobalKey<NavigatorState>();

  /// scaffoldKey for get rootContext
  ///
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  static late DialogProvider? _instance;

  /// initToast initialize toast
  ///
  Widget Function(BuildContext, Widget?) init() {
    return initToast();
  }
}

/// initToast initialize toast
///
@visibleForTesting
Widget Function(BuildContext, Widget?) initToast() {
  return EasyLoading.init(builder: (ctx, w) {
    return MaxScaleTextWidget(
      child: w!,
    );
  });
}

/// RootContext return context from navigatorKey
///
BuildContext get rootContext {
  assert(DialogProvider._instance != null, 'please initialize DialogProvider before App()');
  final nKey = DialogProvider._instance!.scaffoldKey;
  assert(nKey.currentState != null, 'add scaffoldMessengerKey: dialogProvider.navigatorKey in MaterialApp');
  return nKey.currentState!.context;
  /*
  assert(DialogProvider._instance != null, 'please initialize DialogProvider before App()');
  final nKey = DialogProvider._instance!.navigatorKey;
  assert(nKey.currentState != null && nKey.currentState!.overlay != null,
      'please set navigatorKey: dialogProvider.navigatorKey in MaterialApp');
  return nKey.currentState!.overlay!.context;
  */
}

/// prevent user set scale too big, the layout may not show correctly
///
class MaxScaleTextWidget extends StatelessWidget {
  final Widget child;

  const MaxScaleTextWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    var scale = math.min(1.2, data.textScaleFactor);
    return MediaQuery(
      data: data.copyWith(textScaleFactor: scale),
      child: child,
    );
  }
}
