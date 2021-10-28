import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:nested/nested.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/pref/pref.dart' as pref;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'navigator.dart';

/// Context used for mock BuildContext
///
@visibleForTesting
class Context extends Mock implements widgets.BuildContext {}

/// useTestFont set text scale to 1/2, cause font in flutter test is bigger than real device, need scale down
///
///     testing.useTestFont(tester);
///
@visibleForTesting
void useTestFont(WidgetTester tester) {
  tester.binding.window.textScaleFactorTestValue = 0.5; // test font is bigger than real device, need scale down
}

/// navigatorObserver is navigator observer
///
@visibleForTesting
var navigatorObserver = NavigatorMock();

/// mockApp run a mock app for testing
///
@visibleForTesting
Future<void> mockApp(
  WidgetTester tester, {
  List<SingleChildWidget>? providers,
  required Widget child,
}) async {
  useTestFont(tester);
  pref.mock({});

  await tester.pumpWidget(Provider(
      create: (_) => dialog.DialogProvider(),
      child: Consumer<dialog.DialogProvider>(
        builder: (context, dialogProvider, _) => MaterialApp(
          navigatorObservers: [navigatorObserver],
          navigatorKey: dialogProvider.navigatorKey,
          builder: dialogProvider.init(),
          home: providers != null
              ? MultiProvider(
                  providers: providers,
                  child: child,
                )
              : child,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            i18n.LocaleDelegate(),
          ],
          supportedLocales: const [
            Locale('en', 'US'),
          ],
        ),
      )));
  await tester.pumpAndSettle();
}
