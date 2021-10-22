import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested/nested.dart';
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/pref.dart' as pref;
import 'navigator.dart';

var mockNavigator = NavigatorMock();

Future<void> mockApp(
  WidgetTester tester, {
  List<SingleChildWidget>? providers,
  required Widget child,
}) async {
  tester.binding.window.textScaleFactorTestValue = 0.5; // test font is bigger than real device, need scale down
  // ignore: invalid_use_of_visible_for_testing_member
  pref.mock({});

  Widget app = MaterialApp(
    navigatorObservers: [mockNavigator],
    home: providers != null
        ? MultiProvider(
            providers: providers,
            child: child,
          )
        : child,
    navigatorKey: dialog.navigatorKey,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      i18n.LocaleDelegate(),
    ],
    supportedLocales: const [
      Locale('en', 'US'),
    ],
    builder: dialog.init(),
  );

  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}
