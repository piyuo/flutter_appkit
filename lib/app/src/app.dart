import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/error/error.dart' as error;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/db/db.dart' as db;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:beamer/beamer.dart';

/// branchMaster is The current tip-of-tree, absolute latest cutting edge build. Usually functional, though sometimes we accidentally break things
///
const branchMaster = 'master';

/// branchBeta We will branch from master for a new beta release at the beginning of the month, usually the first Monday
///
const branchBeta = 'beta';

/// branchStable is a a branch that has been stabilized on beta will become our next stable branch and we will create a stable release from that branch. We recommend that you use this channel for all production app releases.
///
const branchStable = 'stable';

/// branchDebug is a a branch that always direct remove service url to http://localhost:8080
///
const branchDebug = 'debug';

/// _branch used in command pattern, determine which branch to use, default is master branch
///
String _branch = branchMaster;

/// branch used in command pattern, determine which branch to use, default is master branch
///
String get branch => _branch;

@visibleForTesting
set branch(String value) => _branch = value;

/// _appName is application name, used in log
///
String _appName = '';

/// appName is application name, used in log
///
String get appName => _appName;

@visibleForTesting
set appName(String value) => _appName = value;

/// _serviceEmail is service email, alert dialog will guide user to send email
///
String _serviceEmail = '';

/// serviceEmail is service email, alert dialog will guide user to send email
///
String get serviceEmail => _serviceEmail;

/// RouterBuilder used in web to build a route
///
typedef RouteBuilder = Widget Function(BuildContext context, Map<String, String> arguments);

/// user identity
///
///     vars.userID='user-store'
String _userID = '';
String get userID => _userID;
set userID(String value) {
  log.log('[app] set userID=$value');
  _userID = value;
}

/// start application
void start({
  required String appName,
  required Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)> routes,
  LocalizationsDelegate<dynamic>? l10nDelegate,
  List<SingleChildWidget>? providers,
  String backendBranch = branchMaster,
  String serviceEmail = 'support@piyuo.com',
  ThemeData? theme,
  ThemeData? darkTheme,
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
    locationBuilder: RoutesLocationBuilder(
      routes: routes,
    ),
  );

  Future.microtask(() async {
    // init db
    await db.init();
    // init cache
    await cache.init();
    // run app
    return error.watch(() => runApp(MultiProvider(
          providers: [
            Provider(create: (_) => dialog.DialogProvider()),
            ChangeNotifierProvider(create: (_) => i18n.I18nProvider()),
            if (providers != null) ...providers,
          ],
          child: Consumer2<dialog.DialogProvider, i18n.I18nProvider>(
            builder: (context, dialogProvider, i18nProvider, __) => MaterialApp.router(
              scaffoldMessengerKey: dialogProvider.scaffoldMessengerKey,
              builder: dialogProvider.init(),
              debugShowCheckedModeBanner: false,
              theme: theme ?? ThemeData(brightness: Brightness.light),
              darkTheme: darkTheme ?? ThemeData(brightness: Brightness.dark),
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
            ),
          ),
        )));
  });
}
