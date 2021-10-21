import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:libcli/log.dart' as log;
import 'package:libcli/error.dart' as error;
import 'package:libcli/dialog.dart' as dialog;
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/page_route/page_route.dart' as page_route;

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
  log.log('[env] set userID=$value');
  _userID = value;
}

/// start application
void start({
  required String appName,
  required Route? Function(String name) routes,
  String backendBranch = branchMaster,
  String serviceEmail = 'support@piyuo.com',
  ThemeData? theme,
  ThemeData? darkTheme,
}) {
  // init env
  log.log('[env] start $appName, branch=$branch');
  _branch = branch;
  _appName = appName;
  _serviceEmail = serviceEmail;
  //Provider.debugCheckInvalidValueType = null;
  //WidgetsFlutterBinding.ensureInitialized();

  //routes
  page_route.init();

  // run app
  error.watch(() => runApp(
        MaterialApp(
          navigatorKey: dialog.navigatorKey,
          builder: dialog.init(),
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          //locale: localeModel.locale,
          //localeListResolutionCallback: (locales, supportedLocales) {
          //  return i18n.determineLocale(locales);
          //},
          localizationsDelegates: [
            i18n.LocaleDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
          ],
          onGenerateRoute: (RouteSettings settings) {
            String name = page_route.listen(settings);
            if (name == '') {
              // for web with url route, return null to skip default route
              return null;
            }
            Route? route = routes(name);
            if (route != null) {
              return route;
            }
            return MaterialPageRoute(
                builder: (_) => Scaffold(
                      body: Center(
                        child: Text('404! ${settings.name} not found'),
                      ),
                    ));
          },
        ),
      ));
}
