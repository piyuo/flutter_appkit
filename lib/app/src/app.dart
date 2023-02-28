import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:libcli/database/database.dart' as database;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:beamer/beamer.dart';
import 'error.dart';
import 'language_provider.dart';

/// _appName is application name, used in log
String _appName = '';

/// appName is application name, used in log
String get appName => _appName;

@visibleForTesting
set appName(String value) => _appName = value;

/// _serviceEmail is service email, alert dialog will guide user to send email
String _serviceEmail = '';

/// serviceEmail is service email, alert dialog will guide user to send email
String get serviceEmail => _serviceEmail;

/// RouterBuilder used in web to build a route
typedef RouteBuilder = Widget Function(BuildContext context, Map<String, String> arguments);

/// start application
/// ```dart
///   await start(
///    name: 'app',
///    builder: () async => const [],
///    routes: {
///      '/': (context, state, data) => const HomeScreen(),
///    },
///   );
/// ```
Future<void> start({
  required Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)> routes,
  String name = '',
  Future<List<SingleChildWidget>> Function()? builder,
  String initialRoute = '/',
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
  Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
  String serviceEmail = 'support@piyuo.com',
  ThemeData? theme,
  ThemeData? darkTheme,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  // init cache && db
  _appName = name;
  _serviceEmail = serviceEmail;
  //Provider.debugCheckInvalidValueType = null;

  //routes
  if (kIsWeb) {
    Beamer.setPathUrlStrategy();
  }

  // put delegate outside of build to avoid hot reload error
  final beamerDelegate = BeamerDelegate(
    initialPath: initialRoute,
    locationBuilder: RoutesLocationBuilder(
      routes: routes,
    ),
  );

  await database.init();
  // init cache
  await cache.init();

  // build app provider
  final providers = builder == null ? <SingleChildWidget>[] : await builder();
  // run app
  return watch(() => runApp(LifecycleWatcher(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<LanguageProvider>(
              create: (context) => LanguageProvider(supportedLocales.toList()),
            ),
            ...providers,
          ],
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) => delta.GlobalContextSupport(
                child: MaterialApp.router(
              builder: (context, child) {
                Widget childWrap = dialog.init()(context, child);
                return ScrollConfiguration(
                  behavior: const ScrollBehaviorModified(),
                  child: childWrap,
                );
              },
              debugShowCheckedModeBanner: false,
              theme: theme,
              darkTheme: darkTheme,
              locale: languageProvider.preferredLocale,
              localizationsDelegates: [
                ...localizationsDelegates,
                ...i18n.localizationsDelegates,
              ],
              supportedLocales: languageProvider.supportedLocales,
              routeInformationParser: BeamerParser(),
              routerDelegate: beamerDelegate,
              backButtonDispatcher: BeamerBackButtonDispatcher(
                delegate: beamerDelegate,
              ),
            )),
          ),
        ),
      )));
}

/// LifecycleWatcher watch app life cycle
class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({
    required this.child,
    Key? key,
  }) : super(key: key);

  /// child to show
  final Widget child;

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    debugPrint('appLifeCycleState dispose');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    /// only work on iOS/Android platform
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        debugPrint('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        debugPrint('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        debugPrint('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        debugPrint('appLifeCycleState detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
