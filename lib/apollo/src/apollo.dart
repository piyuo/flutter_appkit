import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;
import 'error.dart';

/// _serviceEmail is service email, alert dialog will guide user to send email
String _serviceEmail = '';

/// serviceEmail is service email, alert dialog will guide user to send email
String get serviceEmail => _serviceEmail;

/// RouterBuilder used in web to build a route
//typedef RouteBuilder = Widget Function(BuildContext context, Map<String, String> arguments);

typedef RoutesBuilder = Map<Pattern, dynamic Function(BuildContext, BeamState, Object?)> Function();

/// start application
/// ```dart
/// await start(
///   routesBuilder: () => {
///      '/': (context, state, data) => const HomeScreen(),
///   },
/// );
/// ```
Future<void> start({
  required RoutesBuilder routesBuilder,
  required Widget Function(Widget) appBuilder,
  Iterable<Locale> supportedLocales = const <Locale>[Locale('en', 'US')],
  String initialRoute = '/',
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
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
  return watch(
    () => runApp(
      LifecycleWatcher(
        child: appBuilder(
          delta.GlobalContextSupport(
            child: MaterialApp.router(
              builder: (context, child) {
                Widget childWrap = dialog.init()(context, child);
                return ScrollConfiguration(
                  behavior: const ScrollBehaviorModified(),
                  child: childWrap,
                );
              },
              debugShowCheckedModeBanner: false,
              theme: theme != null ? adjustFontSpacing(theme) : null,
              darkTheme: darkTheme != null ? adjustFontSpacing(darkTheme) : null,
              //locale: languageProvider.preferredLocale,
              localizationsDelegates: [
                ...localizationsDelegates,
                ...i18n.localizationsDelegates,
              ],
              supportedLocales: supportedLocales,
              routeInformationParser: BeamerParser(),
              routerDelegate: beamerDelegate,
              backButtonDispatcher: BeamerBackButtonDispatcher(
                delegate: beamerDelegate,
              ),
            ),
          ),
        ),
      ),
    ),
  );
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
      case AppLifecycleState.hidden:
        debugPrint('appLifeCycleState hidden');
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

/// adjustFontSpacing fix text labels on Flutter's MaterialApp looks worse on iOS and macOS
/// https://reinhart1010.id/blog/2023/02/11/why-text-labels-on-flutters-materialapp-looks-worse-on-ios-and-macos
ThemeData adjustFontSpacing(ThemeData theme) {
  if (kIsWeb || !(UniversalPlatform.isIOS || UniversalPlatform.isMacOS)) return theme;
  return theme.copyWith(
    textTheme: theme.textTheme.copyWith(
      bodyLarge: theme.textTheme.bodyLarge?.copyWith(letterSpacing: -0.31),
      bodyMedium: theme.textTheme.bodyMedium?.copyWith(letterSpacing: -0.15),
      bodySmall: theme.textTheme.bodySmall?.copyWith(letterSpacing: 0),
      displayLarge: theme.textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.29 - 1.5,
      ),
      displayMedium: theme.textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.35 - 1.5,
      ),
      displaySmall: theme.textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.37 - 1.5,
      ),
      headlineLarge: theme.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.41 - 1.5,
      ),
      headlineMedium: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.38 - 1.5,
      ),
      headlineSmall: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.07 - 1.5,
      ),
      labelLarge: theme.textTheme.labelLarge?.copyWith(letterSpacing: -0.15),
      labelMedium: theme.textTheme.labelMedium?.copyWith(letterSpacing: 0),
      labelSmall: theme.textTheme.labelSmall?.copyWith(letterSpacing: 0.06),
      titleLarge: theme.textTheme.titleLarge?.copyWith(letterSpacing: -0.26),
      titleMedium: theme.textTheme.titleMedium?.copyWith(letterSpacing: -0.31),
      titleSmall: theme.textTheme.titleSmall?.copyWith(letterSpacing: -0.15),
    ),
  );
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
  final beamerDelegate = BeamerDelegate(
    initialPath: initialRoute,
    locationBuilder: (RouteInformation info, BeamParameters? param) {
      final routesLocationBuilder = RoutesLocationBuilder(routes: routesBuilder());
      return routesLocationBuilder(info, param);
    },
  );
*/
