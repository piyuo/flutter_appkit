import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_platform/universal_platform.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/auth/auth.dart' as auth;
import 'package:libcli/global/global.dart' as global;
import 'error.dart';

/// _serviceEmail is service email, alert dialog will guide user to send email
String _serviceEmail = '';

/// serviceEmail is service email, alert dialog will guide user to send email
String get serviceEmail => _serviceEmail;

/// Routes is a map of route pattern and builder
typedef Routes = Map<Pattern, dynamic Function(BuildContext, BeamState, Object? data)>;

/// start application
/// ```dart
/// await start(
///   routes:  {
///      '/': (context, state, data) => const HomeScreen(),
///   },
/// );
/// ```
Future<void> start({
  required Routes routes,
  String authServiceUrl = '', //https://auth-us.piyuo.com/?q'
  Widget Function(Widget)? appBuilder,
  String initialRoute = '/',
  Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
  String serviceEmail = 'support@piyuo.com',
  ThemeData? theme,
  ThemeData? darkTheme,
}) async {
  if (kReleaseMode) {
    // avoid print debug message in release mode
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

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
    locationBuilder: RoutesLocationBuilder(routes: routes).call,
  );

  final router = delta.GlobalContextSupport(
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
      locale: i18n.locale,
      supportedLocales: i18n.supportedLocales,
      localizationsDelegates: [
        ...localizationsDelegates,
        ...i18n.localizationsDelegates,
      ],
      routeInformationParser: BeamerParser(),
      routerDelegate: beamerDelegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: beamerDelegate),
    ),
  );

  // run app
  return watch(
    () => runApp(
      LifecycleWatcher(
        child: MultiProvider(
          providers: [
            Provider<auth.AuthService>(
              create: (_) => auth.AuthService(authServiceUrl),
            ),
            ChangeNotifierProvider<global.LanguageProvider>(
              create: (_) => global.LanguageProvider(),
            ),
            ChangeNotifierProvider<global.SessionProvider>(
              create: (context) => global.SessionProvider(loader: (global.Token? refreshToken) async {
                if (refreshToken != null) {
                  final authService = auth.AuthService.of(context);
                  var response = await authService.send(
                    auth.LoginTokenAction(refreshToken: refreshToken.value), // refresh ticket
                  );
                  if (response is auth.LoginTokenResponse) {
                    if (response.result == auth.LoginTokenResponse_Result.RESULT_OK) {
                      return global.Session.fromAccess(response.access);
                    }
                  }
                }
                return null;
              }),
            ),
          ],
          child: Consumer<global.LanguageProvider>(
            // don't put sessionProvider here, it won't work,it possible because sessionProvider change it value on other route
            builder: (context, languageProvider, _) => appBuilder != null ? appBuilder(router) : router,
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
    super.key,
  });

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

/// currentRoute return current beamer route
currentRoute(BuildContext context) {
  return Beamer.of(context).currentBeamLocation.state.routeInformation.uri.path;
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
  final beamerDelegate = BeamerDelegate(
    initialPath: initialRoute,
    locationBuilder: (RouteInformation info, BeamParameters? param) {
      final routesLocationBuilder = RoutesLocationBuilder(routes: routesBuilder());
      return routesLocationBuilder(info, param);
    },
  );


            Provider<auth.AuthService>(
              create: (context) => auth.AuthService()
                ..accessTokenBuilder = () async {
                  final session = await apollo.SessionProvider.of(context).getValidSession();
                  if (session == null) {
                    return null;
                  }
                  return session.accessToken.value;
                }
                ..urlBuilder = () => 'https://auth-us${apollo.backendBranchUrl}.piyuo.com/?q',
            ),
            ChangeNotifierProvider<apollo.LanguageProvider>(
              create: (context) => apollo.LanguageProvider(),
            ),
            ChangeNotifierProvider<apollo.SessionProvider>(
              create: (_) => apollo.SessionProvider(loader: (apollo.Token? refreshToken) async {
                if (refreshToken != null) {
                  final authService = auth.AuthService.of(delta.globalContext);
                  var resp = await authService.send(
                    auth.CmdSignupVerify(), // refresh ticket
                  );
                  if (resp is auth.CmdSignupVerify) {
                    return apollo.Session(
                      userId: 'user1',
                      accessToken: apollo.Token(
                        value: 'fakeAccessKey2',
                        expired: DateTime.now().add(const Duration(seconds: 30)),
                      ),
                      refreshToken: refreshToken,
                    );
                  }
                }
                return null;
              }),
            ),
            Provider<net.HttpProtoFileProvider>(
              // for protobuf file
              create: (_) => net.HttpProtoFileProvider(),
            ),

            ChangeNotifierProvider<apollo.SessionProvider>(
              create: (_) => apollo.SessionProvider(loader: (apollo.Token? refreshToken) async {
                if (refreshToken != null) {
                  final authService = auth.AuthService.of(delta.globalContext);
                  var resp = await authService.send(
                    auth.CmdSignupVerify(), // refresh ticket
                  );
                  if (resp is auth.CmdSignupVerify) {
                    return apollo.Session(
                      userId: resp.id,
                      accessToken: apollo.Token(
                        value: 'fakeAccessKey2',
                        expired: DateTime.now().add(const Duration(seconds: 30)),
                      ),
                      refreshToken: refreshToken,
                    );
                  }
                }
                return null;
              }),
            ),

*/
