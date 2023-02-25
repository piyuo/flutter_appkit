import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/database/database.dart' as database;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:beamer/beamer.dart';
import 'error.dart';

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

String _userID = '';

/// userID is user identity
/// ```dart
/// vars.userID='user-store'
/// ```
String get userID => _userID;

/// userID is user identity
/// ```dart
/// vars.userID='user-store'
/// ```
set userID(String value) {
  log.log('[app] set userID=$value');
  _userID = value;
}

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
  LocalizationsDelegate<dynamic>? l10nDelegate,
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
        providers: providers,
        child: delta.GlobalContextSupport(
            child: MaterialApp.router(
          builder: (context, child) {
            dialog.init();
            return ScrollConfiguration(
              behavior: const ScrollBehaviorModified(),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          theme: theme ??
              ThemeData(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                ),
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.grey.shade700,
                  elevation: 1,
                ),
              ),
          darkTheme: darkTheme ??
              ThemeData(
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.blue,
                  brightness: Brightness.dark,
                ),
                appBarTheme: AppBarTheme(
                  foregroundColor: Colors.grey.shade100,
                  elevation: 1,
                ),
              ),
          locale: i18n.locale,
          localizationsDelegates: [
            if (l10nDelegate != null) l10nDelegate,
            ...i18n.localizationsDelegates,
          ],
          supportedLocales: i18n.supportedLocales,
          routeInformationParser: BeamerParser(),
          routerDelegate: beamerDelegate,
          backButtonDispatcher: BeamerBackButtonDispatcher(
            delegate: beamerDelegate,
          ),
        )),
      ))));
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
