import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/dialog/dialog.dart' as dialog;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/log/log.dart' as log;
import 'package:intl/intl.dart';
import 'package:beamer/beamer.dart';
import '../app.dart';

main() async {
  await start(
    name: 'app',
    builder: () async => const [],
    supportedLocales: const [
      Locale('en'),
      Locale('en', 'US'),
      Locale('zh'),
      Locale('zh', 'CN'),
      Locale('zh', 'TW'),
    ],
    routes: {
      '/': (context, state, data) => const BeamPage(
            key: ValueKey('home'),
            title: 'Home',
            child: AppExample(color: null),
          ),
      '/other/:id': (context, state, data) {
        final id = state.pathParameters['id']!;
        return BeamPage(
          key: ValueKey('other-$id'),
          title: 'other',
          child: AppExample(
            color: Colors.red,
            data: {
              'id': id,
            },
          ),
        );
      },
      '/other': (context, state, data) => BeamPage(
            key: const ValueKey('other'),
            title: 'other',
            child: AppExample(
              color: Colors.red,
              data: data,
            ),
          ),
    },
  );
}

class AppExample extends StatefulWidget {
  const AppExample({
    required this.color,
    this.data,
    Key? key,
  }) : super(key: key);

  final Color? color;

  final dynamic data;

  @override
  State<StatefulWidget> createState() => AppExampleState();
}

class AppExampleState extends State<AppExample> {
  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      future: () async {
        final languageProvider = LanguageProvider.of(context);
        await languageProvider.init();
      },
      builder: () => SafeArea(
          child: Column(
        children: [
          Expanded(
            child: _languageProvider(context),
            // child: _routing(context, widget.data),
            //child: _setPageTitle(context),
          ),
          Container(
              color: Colors.black,
              child: Wrap(children: [
                OutlinedButton(
                  child: const Text('show alert use global context'),
                  onPressed: () {
                    dialog.alert('hello');
                  },
                ),
                testing.ExampleButton(
                  label: 'error screen',
                  builder: () => _errorScreen(context),
                ),
                testing.ExampleButton(
                  label: 'network error screen',
                  builder: () => _networkErrorScreen(context),
                ),
                testing.ExampleButton(
                  label: 'routing',
                  useScaffold: false,
                  builder: () => _routing(context, widget.data),
                ),
                testing.ExampleButton(
                  label: 'localization',
                  builder: () => _languageProvider(context),
                ),
                testing.ExampleButton(
                  label: 'test root context with dialog',
                  builder: () => _testRootContext(context),
                ),
                testing.ExampleButton(
                  label: 'scroll behavior',
                  useScaffold: false,
                  builder: () => _scrollBehavior(context),
                ),
                testing.ExampleButton(
                  label: 'set page title',
                  useScaffold: false,
                  builder: () => _setPageTitle(context),
                ),
                testing.ExampleButton(
                  label: 'error',
                  builder: () => _error(context),
                ),
                testing.ExampleButton(label: 'loadingScreen ready', builder: () => _loadingScreenReady(context)),
                testing.ExampleButton(label: 'loadingScreen error', builder: () => _loadingScreenError(context)),
                testing.ExampleButton(
                    label: 'loadingScreen network error', builder: () => _loadingScreenNetworkError(context)),
              ]))
        ],
      )),
    );
  }

  Widget _errorScreen(BuildContext context) {
    try {
      throw Exception('http://piyuo.com/my_burger/.pb not found');
    } catch (e, s) {
      log.error(e, s);
    }
    return ErrorScreen(onRetry: () {});
  }

  Widget _networkErrorScreen(BuildContext context) {
    try {
      throw Exception('http://piyuo.com/my_burger/.pb not found');
    } catch (e, s) {
      log.error(e, s);
    }
    return NetworkErrorScreen(onRetry: () {});
  }

  Widget _routing(BuildContext context, dynamic data) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.color,
        leading: beamBack(context),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        if (data != null) Text('id=${data["id"]}'),
        OutlinedButton(
            child: const Text('beam to other'),
            onPressed: () {
              context.beamToNamed('/other');
            }),
        OutlinedButton(
            child: const Text('beam to other with path param'),
            onPressed: () {
              context.beamToNamed('/other/2fb83m');
            }),
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
            child: const Text('root pop'),
            onPressed: () {
              rootPop(context);
            }),
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

  Widget _languageProvider(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, languageProvider, child) {
      String defaultLocale = Intl.defaultLocale ?? '';
      return Column(
        children: [
          Text(context.i18n.okButtonText),
          Text(Localizations.localeOf(context).toString()),
          Text('intl.defaultLocale=$defaultLocale'),
          Text('current locale=${i18n.localeName}, date=${i18n.formatDate(DateTime.now())}'),
          OutlinedButton(
              child: const Text('get locale to system default'),
              onPressed: () {
                languageProvider.setPreferredLocale(null);
              }),
          OutlinedButton(
              child: const Text('change locale to en'),
              onPressed: () {
                languageProvider.setPreferredLocale(const Locale('en'));
              }),
          OutlinedButton(
              child: const Text('change locale to zh'),
              onPressed: () {
                languageProvider.setPreferredLocale(const Locale('zh', 'CN'));
              }),
          OutlinedButton(
              child: const Text('change locale to zh_TW'),
              onPressed: () {
                languageProvider.setPreferredLocale(const Locale('zh', 'TW'));
              }),
        ],
      );
    });
  }

  Widget _loadingScreenError(BuildContext context) {
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

  Widget _loadingScreenNetworkError(BuildContext context) {
    return TextButton(
      child: const Text('loading screen network error'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return LoadingScreen(
            future: () async {
              await Future.delayed(const Duration(seconds: 3));
              throw const RetryableException('error'); //TimeoutException('error');
            },
            builder: () => Container(width: 100, height: 100, color: Colors.red),
          );
        }));
      },
    );
  }

  Widget _loadingScreenReady(BuildContext context) {
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

  Widget _setPageTitle(BuildContext context) {
    return OutlinedButton(
      child: const Text('set page title'),
      onPressed: () {
        setWebPageTitle('hello');
      },
    );
  }

  Widget _testRootContext(BuildContext context) {
    return OutlinedButton(
      child: const Text('alert'),
      onPressed: () {
        dialog.alert('hello');
      },
    );
  }

  Widget _scrollBehavior(BuildContext context) {
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
}

Widget _error(BuildContext context) {
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
              await eventbus.broadcast(command.RequestTimeoutEvent(isServer: false, exception: e, url: 'http://mock'));
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
