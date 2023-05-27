import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;
import 'error.dart';
import 'language_provider.dart';

/// _kDefaultMaintenancePeriod is period to start maintenance after app start
const _kDefaultMaintenancePeriod = Duration(seconds: 30);

/// _serviceEmail is service email, alert dialog will guide user to send email
String _serviceEmail = '';

/// serviceEmail is service email, alert dialog will guide user to send email
String get serviceEmail => _serviceEmail;

/// RouterBuilder used in web to build a route
//typedef RouteBuilder = Widget Function(BuildContext context, Map<String, String> arguments);

typedef RoutesBuilder = Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)> Function();

/// start application
/// ```dart
///   await start(
///    name: 'app',
///    builder: () async => const [],
///    routesBuilder: () => {
///      '/': (context, state, data) => const HomeScreen(),
///    },
///   );
/// ```
Future<void> start({
  required RoutesBuilder routesBuilder,
  String initialRoute = '/',
  List<SingleChildWidget> Function()? dependencyBuilder,
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
  Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
  String serviceEmail = 'support@piyuo.com',
  ThemeData? theme,
  ThemeData? darkTheme,
}) async {
  //  WidgetsFlutterBinding.ensureInitialized(); no need to call this
  // init cache && db
  _serviceEmail = serviceEmail;

  // make sure web use path url is not include #
  if (kIsWeb) {
    Beamer.setPathUrlStrategy();
  }

  // put delegate outside of build to avoid hot reload error
  final beamerDelegate = BeamerDelegate(
    initialPath: initialRoute,
    locationBuilder: RoutesLocationBuilder(routes: routesBuilder()),
  );

  // run app
  return watch(() => runApp(LifecycleWatcher(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<LanguageProvider>(
              create: (context) => LanguageProvider(supportedLocales.toList()),
            ),
            if (dependencyBuilder != null) ...dependencyBuilder()
          ],
          child: Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) {
              return delta.GlobalContextSupport(
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
              ));
            },
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
    Future.delayed(_kDefaultMaintenancePeriod).then((_) => delta.webImageClearCache());
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

/// redirect to other section of app, it open route in native mode, redirect to web url in web mode
void redirect(
  BuildContext context,
  String path,
) {
  if (kIsWeb) {
    final l = html.window.location;
    l.href = ('${l.protocol}//${l.host}$path');
    return;
  }
  Beamer.of(context).beamToNamed(path);
}

/// goHome go to home page
void goHome(BuildContext context) => redirect(context, '/');

/// goBack go to previous page
void goBack(BuildContext context) {
  if (kIsWeb) {
    html.window.history.back();
    return;
  }
  Beamer.of(context).beamBack();
}

/// buildBackButton put back button in app entry Scaffold.appBar
Widget? buildBackButton() {
  if (kIsWeb && html.window.location.pathname != '/' && html.window.history.length > 1) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: () => html.window.history.back(),
    );
  }
  return null;
}

/// setWebPageTitle will set html page title if run in web mode
void setWebPageTitle(String title) {
  if (kIsWeb) {
    html.document.title = title;
  }
}



/*
/// isRootCanPop return true if root page still can go back to previous page
bool isRootCanPop(BuildContext context) {
  return html.window.location.pathname == '/' && html.window.location.href.contains('back=1');
}

/// rootPop go back to previous page
void rootPop(BuildContext context) {
  if (html.window.history.length > 0) {
    log.debug('[app] back history');
    html.window.history.back();
  }
  log.debug('[app] close tab');
  html.window.close();
}

 */


/*
  await database.init();
  // init cache
  await cache.init();
*/
/*
  final beamerDelegate = BeamerDelegate(
    initialPath: initialRoute,
    locationBuilder: (RouteInformation info, BeamParameters? param) {
      final routesLocationBuilder = RoutesLocationBuilder(routes: routesBuilder());
      return routesLocationBuilder(info, param);
    },
  );
*/
