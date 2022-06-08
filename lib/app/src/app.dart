import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/database/database.dart' as database;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/error/error.dart' as error;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:beamer/beamer.dart';
import '../../dialog/src/global_context_support.dart';

/// branchMaster is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
const branchMaster = 'master';

/// branchBeta We will branch from master for a new beta release at the beginning of the month, usually the first Monday
const branchBeta = 'beta';

/// branchStable is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
const branchStable = 'stable';

/// branchDebug is a a branch that always direct remove service url to http://localhost:8080
const branchDebug = 'debug';

/// _branch used in command pattern, determine which branch to use, default is master branch
String _branch = branchMaster;

/// branch used in command pattern, determine which branch to use, default is master branch
String get branch => _branch;

@visibleForTesting
set branch(String value) => _branch = value;

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
void start({
  required String appName,
  required Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)> routes,
  String initialRoute = '/',
  LocalizationsDelegate<dynamic>? l10nDelegate,
  List<SingleChildWidget>? providers,
  String backendBranch = branchMaster,
  String serviceEmail = 'support@piyuo.com',
  ThemeData? theme,
  ThemeData? darkTheme,
  Future<void> Function()? onBeforeStart,
}) {
  WidgetsFlutterBinding.ensureInitialized();
  // init cache && db
  log.log('[app] start $appName, branch=$branch');
  _branch = branch;
  _appName = appName;
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

  Future.microtask(() async {
    // init database path
    await database.init();
    // init cache
    await cache.init();

    if (onBeforeStart != null) {
      await onBeforeStart();
    }
    // run app
    return error.watch(() => runApp(LifecycleWatcher(
            child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => i18n.I18nProvider()),
            if (providers != null) ...providers,
          ],
          child: Consumer<i18n.I18nProvider>(
            builder: (context, i18nProvider, __) => dialog.GlobalContextSupport(
                child: MaterialApp.router(
              builder: dialog.init(),
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
              locale: i18nProvider.overrideLocale,
              localizationsDelegates: [
                if (l10nDelegate != null) l10nDelegate,
                ...i18nProvider.localizationsDelegates,
              ],
              supportedLocales: i18nProvider.supportedLocales,
              routeInformationParser: BeamerParser(),
              routerDelegate: beamerDelegate,
              backButtonDispatcher: BeamerBackButtonDispatcher(
                delegate: beamerDelegate,
              ),
            )),
          ),
        ))));
  });
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
