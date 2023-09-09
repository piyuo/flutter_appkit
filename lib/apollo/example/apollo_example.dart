import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/delta/delta.dart' as delta;
import 'package:intl/intl.dart';
import 'package:beamer/beamer.dart';
import '../apollo.dart';

final _navigatorKey = GlobalKey();

main() async {
  await start(
    theme: testing.theme(),
    darkTheme: testing.darkTheme(),
    appBuilder: (child) => child,
    routes: {
      '/': (context, state, data) => BeamPage(
            key: const ValueKey('home'),
            title: 'home [${i18n.localeKey}]',
            child: const AppExample(
              color: null,
            ),
          ),
      '/other/:id': (context, state, data) {
        final id = state.pathParameters['id']!;
        return BeamPage(
          key: ValueKey('other-$id'),
          title: 'other-$id [${i18n.localeKey}]',
          child: const AppExample(
            color: Colors.red,
          ),
        );
      },
      '/other': (context, state, data) => BeamPage(
            key: const ValueKey('other'),
            title: 'other [${i18n.localeKey}]',
            child: const AppExample(
              color: Colors.red,
            ),
          ),
    },
  );
}

class AppExample extends StatefulWidget {
  const AppExample({
    required this.color,
    Key? key,
  }) : super(key: key);

  final Color? color;

  @override
  State<StatefulWidget> createState() => AppExampleState();
}

class AppExampleState extends State<AppExample> {
  @override
  Widget build(BuildContext context) {
    navigationScaffold() {
      return NavigationScaffold(
        railWidth: 0,
        leadingInRail: Container(width: 256, height: 100, color: Colors.blue),
        trailingInRail: Container(width: 256, height: 100, color: Colors.green),
        destinations: const [
          Navigation(title: 'Dashboard', icon: Icons.dashboard),
          Navigation(title: 'Message', icon: Icons.chat, badge: '5'),
          Navigation(title: 'Reservation', icon: Icons.event),
          Navigation(title: 'Stays', icon: Icons.home),
          Navigation(title: 'Settings', icon: Icons.settings),
        ],
        selectedIndex: 0,
        onSelected: (index) {
          debugPrint(index.toString());
        },
        body: Container(color: Colors.red, height: 100),
      );
    }

    tryOpenWebUrl() {
      return OutlinedButton(
        child: const Text('open web url'),
        onPressed: () => openWebUrl(context, 'https://starbucks.com', caption: 'starbucks.com'),
      );
    }

    hypertext() {
      return Padding(
          padding: const EdgeInsets.all(20),
          child: Hypertext(
            children: [
              const Span(text: 'click to print to console '),
              const Bold(text: 'bold'),
              const Bold(text: '         '),
              Link(text: ' say hello ', onPressed: (context, details) => debugPrint('hello world')),
              PopText(
                  text: 'what is ChatGPT?',
                  content:
                      'ChatGPT is a sibling model to InstructGPT, which is trained to follow an instruction in a prompt and provide a detailed response'),
              DocumentLink(text: ' privacy terms ', docName: 'privacy'),
              Url(text: 'http://starbucks.com'),
            ],
          ));
    }

    errorScreen() {
      try {
        throw Exception('http://piyuo.com/my_burger/.pb not found');
      } catch (e, s) {
        log.error(e, s);
      }
      return ErrorScreen(onRetry: () {});
    }

    webApp() {
      return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
          OutlinedButton(
            child: const Text('redirect to other'),
            onPressed: () => redirect(context, '/other'),
          ),
          OutlinedButton(
            child: const Text('go back'),
            onPressed: () => goBack(context),
          ),
          OutlinedButton(
            child: const Text('go home'),
            onPressed: () => goHome(context),
          ),
          OutlinedButton(
            child: const Text('redirect to other with path param'),
            onPressed: () => redirect(context, '/other/2fb83m'),
          ),
          OutlinedButton(
              child: const Text('beam to other with data'),
              onPressed: () {
                context.beamToNamed(
                  '/other',
                  popBeamLocationOnPop: true,
                  data: {
                    'id': '1',
                  },
                );
              }),
          const BeamLink(
            path: '/other',
            child: Text('link:goto app'),
          ),
          const BeamLink(
            path: '/other',
            newTab: true,
            beamBack: true,
            child: Text('link:goto app in new tab'),
          ),
          OutlinedButton(
              child: const Text('navigator push'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(),
                      body: const Text('hello'),
                    ),
                  ),
                );
              }),
          OutlinedButton(
              child: const Text('show snackbar'),
              onPressed: () {
                const snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }),
          OutlinedButton(
              child: const Text('show alert'),
              onPressed: () {
                dialog.alert('hello');
              }),
        ])),
      );
    }

    tryLanguageProvider() {
      return Consumer<LanguageProvider>(builder: (context, languageProvider, child) {
        String defaultLocale = Intl.defaultLocale ?? '';
        return Column(
          children: [
            Text(context.i18n.okButtonText),
            Text(Localizations.localeOf(context).toString()),
            Text('intl.defaultLocale=$defaultLocale'),
            Text('current locale=${i18n.localeKey}, date=${DateTime.now().formattedDate}'),
            OutlinedButton(
                child: const Text('set locale to system default'),
                onPressed: () => languageProvider.setPreferredLocale(null)),
            OutlinedButton(
                child: const Text('change locale to en'),
                onPressed: () => languageProvider.setPreferredLocale(const Locale('en'))),
            OutlinedButton(
                child: const Text('change locale to zh'),
                onPressed: () => languageProvider.setPreferredLocale(const Locale('zh', 'CN'))),
            OutlinedButton(
                child: const Text('change locale to zh_TW'),
                onPressed: () => languageProvider.setPreferredLocale(const Locale('zh', 'TW'))),
            OutlinedButton(
                child: const Text('set support locales to en'),
                onPressed: () => languageProvider.setLocales([const Locale('en', 'US')])),
          ],
        );
      });
    }

    trySessionProvider() {
      return ChangeNotifierProvider<SessionProvider>(
          create: (context) => SessionProvider(loader: (_) async => null),
          child: Consumer<SessionProvider>(builder: (context, sessionProvider, child) {
            return Column(
              children: [
                OutlinedButton(
                    child: const Text('login'),
                    onPressed: () async {
                      await sessionProvider.login(Session(
                        userId: 'user1',
                        accessToken: Token(
                          value: 'fakeAccess',
                          expired: DateTime.now().add(const Duration(seconds: 300)),
                        ),
                        refreshToken: Token(
                          value: 'fakeRefresh',
                          expired: DateTime.now().add(const Duration(seconds: 300)),
                        ),
                        args: {
                          'user': 'user1',
                          'img': 'img1',
                          'region': 'region1',
                        },
                      ));
                    }),
                OutlinedButton(
                    child: const Text('logout'),
                    onPressed: () async {
                      await sessionProvider.logout();
                    }),
              ],
            );
          }));
    }

    loadingScreenError() {
      return TextButton(
        child: const Text('loading screen error'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return LoadingScreen(
              future: () async {
                await Future.delayed(const Duration(seconds: 3));
                throw Exception('error');
              },
              builder: () => Container(width: 100, height: 100, color: Colors.red),
            );
          }));
        },
      );
    }

    loadingScreenNetworkError() {
      return TextButton(
        child: const Text('loading screen network error'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return LoadingScreen(
              future: () async {
                await Future.delayed(const Duration(seconds: 1));
                throw const utils.TryAgainLaterException('error'); //TimeoutException('error');
              },
              builder: () => Container(width: 100, height: 100, color: Colors.red),
            );
          }));
        },
      );
    }

    loadingScreenDefault() {
      return TextButton(
        child: const Text('provider need wait 3 seconds'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return LoadingScreen(
              future: () async => await Future.delayed(const Duration(seconds: 3)),
              builder: () => const Text('done'),
            );
          }));
        },
      );
    }

    loadingScreenReady() {
      buildChild(isReady) {
        return Container(
            width: 100,
            height: 100,
            color: isReady ? Colors.green : Colors.pink,
            child: Text(isReady ? 'Ready' : 'Loading...', style: const TextStyle(color: Colors.white)));
      }

      return TextButton(
        child: const Text('provider need wait 3 seconds'),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return LoadingScreen(
              future: () async => await Future.delayed(const Duration(seconds: 3)),
              loadingWidgetBuilder: () => buildChild(false),
              builder: () => buildChild(true),
            );
          }));
        },
      );
    }

    testRootContext() {
      return OutlinedButton(
        child: const Text('alert'),
        onPressed: () {
          dialog.alert('hello');
        },
      );
    }

    scrollBehavior() {
      return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(children: [
              Container(height: 500, color: Colors.red),
              Container(height: 500, color: Colors.blue),
              Container(height: 500, color: Colors.yellow),
              Container(height: 500, color: Colors.green),
            ]),
          )));
    }

    trySplitView() {
      return ChangeNotifierProvider<SplitViewProvider>(
          create: (_) => SplitViewProvider(key: '_splitView'),
          child: Consumer<SplitViewProvider>(
              builder: (context, splitterViewProvider, _) => LoadingScreen(
                    future: () async {
                      await splitterViewProvider.init();
                    },
                    builder: () => Row(children: [
                      const SizedBox(width: 50),
                      Expanded(
                          child: SplitView(
                              newNavigatorKey: _navigatorKey,
                              isVertical: false,
                              key: const ValueKey<String>('_first'),
                              splitViewProvider: splitterViewProvider,
                              sideBuilder: (_, splitView) => Container(
                                    color: Colors.blue,
                                    child: Center(
                                        child: ElevatedButton(
                                      child: const Text('side'),
                                      onPressed: () => splitView.showContent(context),
                                    )),
                                  ),
                              contentBuilder: (context, splitView) => Container(
                                    color: Colors.red,
                                    child: Scaffold(
                                      appBar: const delta.ResponsiveAppBar(),
                                      body: Center(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                            return Scaffold(
                                              appBar: const delta.ResponsiveAppBar(),
                                              body: SafeArea(
                                                  child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Container(height: 500, color: Colors.yellow),
                                                  Container(height: 500, color: Colors.blue),
                                                  Container(height: 500, color: Colors.red),
                                                  Container(height: 500, color: Colors.green),
                                                ]),
                                              )),
                                            );
                                          }));
                                        },
                                        child: const Text('main'),
                                      )),
                                    ),
                                  ))),
                    ]),
                  )));
    }

    error() {
      return Wrap(
        children: [
          ElevatedButton(
              child: const Text('throw exception'),
              onPressed: () {
                watch(() => throw Exception('mock exception'));
              }),
          ElevatedButton(
              child: const Text('throw exception twice'),
              onPressed: () {
                watch(() {
                  Future.delayed(const Duration(seconds: 3), () {
                    throw Exception('second exception');
                  });
                  throw Exception('first exception');
                });
              }),
          ElevatedButton(
              child: const Text('firewall block'),
              onPressed: () {
                eventbus.broadcast(command.FirewallBlockEvent('BLOCK_SHORT'));
              }),
          ElevatedButton(
              child: const Text('no internet'),
              onPressed: () async {
                try {
                  throw const SocketException('wifi off');
                } catch (e) {
                  var contract = command.InternetRequiredEvent(exception: e, url: 'http://mock');
                  contract.isInternetConnected = () async {
                    return false;
                  };
                  await eventbus.broadcast(contract);
                }
              }),
          ElevatedButton(
              child: const Text('service not available'),
              onPressed: () async {
                var contract = command.InternetRequiredEvent(url: 'http://mock');
                contract.isInternetConnected = () async {
                  return true;
                };
                contract.isGoogleCloudFunctionAvailable = () async {
                  return true;
                };
                await eventbus.broadcast(contract);
              }),
          ElevatedButton(
              child: const Text('internet blocked'),
              onPressed: () async {
                var contract = command.InternetRequiredEvent(url: 'http://mock');
                contract.isInternetConnected = () async {
                  return true;
                };
                contract.isGoogleCloudFunctionAvailable = () async {
                  return false;
                };
                await eventbus.broadcast(contract);
              }),
          ElevatedButton(
              child: const Text('internal server error'),
              onPressed: () {
                eventbus.broadcast(command.InternalServerErrorEvent());
              }),
          ElevatedButton(
              child: const Text('server not ready'),
              onPressed: () {
                eventbus.broadcast(command.ServerNotReadyEvent());
              }),
          ElevatedButton(
              child: const Text('bad request'),
              onPressed: () {
                eventbus.broadcast(command.BadRequestEvent());
              }),
          ElevatedButton(
              child: const Text('client timeout'),
              onPressed: () async {
                try {
                  throw TimeoutException('client timeout');
                } catch (e) {
                  await eventbus
                      .broadcast(command.RequestTimeoutEvent(isServer: false, exception: e, url: 'http://mock'));
                }
              }),
          ElevatedButton(
              child: const Text('deadline exceeded'),
              onPressed: () async {
                await eventbus.broadcast(command.RequestTimeoutEvent(isServer: true, url: 'http://mock'));
              }),
          ElevatedButton(
              child: const Text('slow network'), onPressed: () => eventbus.broadcast(command.SlowNetworkEvent())),
          ElevatedButton(child: const Text('disk error'), onPressed: () => throw preferences.DiskErrorException()),
        ],
      );
    }

    loginForm() {
      return Column(children: [
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.all(40),
          child: LoginForm(onLoginSucceeded: () => debugPrint('login succeeded')),
        ),
      ]);
    }

    return LoadingScreen(
      future: () async {
        final languageProvider = LanguageProvider.of(context);
        await languageProvider.init();
      },
      builder: () => testing.ExampleScaffold(
        builder: loadingScreenDefault,
        buttons: [
          OutlinedButton(
            child: const Text('show alert use global context'),
            onPressed: () {
              dialog.alert('hello');
            },
          ),
          testing.ExampleButton('NavigationScaffold', useScaffold: false, builder: navigationScaffold),
          testing.ExampleButton('open web url', builder: tryOpenWebUrl),
          testing.ExampleButton('error screen', builder: errorScreen),
          testing.ExampleButton('web_app', useScaffold: false, builder: webApp),
          testing.ExampleButton('language provider', builder: tryLanguageProvider),
          testing.ExampleButton('session provider', builder: trySessionProvider),
          testing.ExampleButton('test root context with dialog', builder: testRootContext),
          testing.ExampleButton('scroll behavior', useScaffold: false, builder: scrollBehavior),
          testing.ExampleButton('error', builder: error),
          testing.ExampleButton('loadingScreen default', builder: loadingScreenDefault),
          testing.ExampleButton('loadingScreen custom', builder: loadingScreenReady),
          testing.ExampleButton('loadingScreen error', builder: loadingScreenError),
          testing.ExampleButton('loadingScreen network error', builder: loadingScreenNetworkError),
          testing.ExampleButton('hypertext', builder: hypertext),
          testing.ExampleButton('SplitView', builder: trySplitView),
          testing.ExampleButton('login form', builder: loginForm, useScaffold: false),
        ],
      ),
    );
  }
}
