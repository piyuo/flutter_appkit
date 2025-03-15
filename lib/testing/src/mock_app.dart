// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/cli/cli.dart' as cli;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/preferences/preferences.dart' as storage;
import 'package:mockito/mockito.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'navigator.dart';

/// Context used for mock BuildContext
///
@visibleForTesting
class Context extends Mock implements widgets.BuildContext {}

@visibleForTesting
get context => Context();

/// useTestFont set text scale to 1/2, cause font in flutter test is bigger than real device, need scale down
///
///     testing.useTestFont(tester);
///
@visibleForTesting
void useTestFont(WidgetTester tester) {
  //tester.binding.window.textScaleFactorTestValue = 0.5; // test font is bigger than real device, need scale down

  tester.binding.platformDispatcher.textScaleFactorTestValue =
      0.5; // test font is bigger than real device, need scale down
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

  final materialApp = cli.GlobalContextSupport(
    child: MaterialApp(
      navigatorObservers: [navigatorObserver],
      home: providers != null
          ? MultiProvider(
              providers: providers,
              child: child,
            )
          : child,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        if (l10nDelegate != null) l10nDelegate,
        ...i18n.localizationsDelegates,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
    ),
  );

  await tester.pumpWidget(
    providers != null
        ? MultiProvider(
            providers: providers,
            child: materialApp,
          )
        : materialApp,
  );
  await tester.pumpAndSettle();
}
