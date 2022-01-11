import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:nested/nested.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/storage/storage.dart' as storage;
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
  required Widget child,
  LocalizationsDelegate<dynamic>? l10nDelegate,
  List<SingleChildWidget>? providers,
}) async {
  useTestFont(tester);
  storage.initForTest({});

  await tester.pumpWidget(MultiProvider(
      providers: [
        Provider(create: (_) => dialog.DialogProvider()),
        ChangeNotifierProvider(create: (_) => i18n.I18nProvider()),
        if (providers != null) ...providers,
      ],
      child: Consumer2<dialog.DialogProvider, i18n.I18nProvider>(
        builder: (context, dialogProvider, i18nProvider, _) => MaterialApp(
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
            if (l10nDelegate != null) l10nDelegate,
            ...i18nProvider.localizationsDelegates,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
          ],
        ),
      )));
  await tester.pumpAndSettle();
}
