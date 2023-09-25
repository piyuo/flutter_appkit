// ignore_for_file: invalid_use_of_visible_for_testing_member

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
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/utils/utils.dart' as utils;
import 'package:libcli/log/log.dart' as log;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:beamer/beamer.dart';
import '../apollo.dart';

final _navigatorKey = GlobalKey();

main() async {
  await start(
    theme: testing.theme(),
    darkTheme: testing.darkTheme(),
    routes: {
      '/': (context, state, data) => const BeamPage(
            key: ValueKey('home'),
            title: 'home',
            child: Example(title: 'home'),
          ),
      '/other/:id': (context, state, data) {
        final id = state.pathParameters['id']!;
        return BeamPage(
          key: ValueKey('other-$id'),
          title: 'other-$id',
          child: Example(title: 'other-$id'),
        );
      },
      '/other': (context, state, data) => const BeamPage(
            key: ValueKey('other'),
            title: 'other',
            child: Example(title: 'other'),
          ),
    },
  );
}

class Example extends StatelessWidget {
  const Example({
    required this.title,
    super.key,
  });

  final String? title;

  /// _load to mock data
  static Future<void> _load(BuildContext context) async {
    final languageProvider = LanguageProvider.of(context);
    final sessionProvider = SessionProvider.of(context);
    await languageProvider.init();
    await sessionProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('title: $title');
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

    goto() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Goto Test'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          OutlinedButton(
            child: const Text('go to other'),
            onPressed: () => goTo(context, '/other'),
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
            child: const Text('go to other with path param'),
            onPressed: () => goTo(context, '/other/2fb83m'),
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
        return Column(
          children: [
            Text(context.i18n.okButtonText),
            Text(Localizations.localeOf(context).toString()),
            Text('current locale=${i18n.locale.toString()}, date=${DateTime.now().formattedDate}'),
            OutlinedButton(
                child: const Text('set locale to system default'),
                onPressed: () => languageProvider.changeLocale(null)),
            OutlinedButton(
                child: const Text('change locale to en'),
                onPressed: () => languageProvider.changeLocale(const Locale('en'))),
            OutlinedButton(
                child: const Text('change locale to zh'),
                onPressed: () => languageProvider.changeLocale(const Locale('zh'))),
            OutlinedButton(
                child: const Text('change locale to zh_TW'),
                onPressed: () => languageProvider.changeLocale(const Locale('zh', 'TW'))),
            OutlinedButton(
                child: const Text('set support locales to en'),
                onPressed: () => languageProvider.limitSupportedLocales([const Locale('en', 'US')])),
          ],
        );
      });
    }

    trySessionProvider() {
      final sessionProvider = SessionProvider.of(context);
      return Column(
        children: [
          OutlinedButton(
              child: const Text('login'),
              onPressed: () async {
                await sessionProvider.login(Session(
                  accessToken: Token(
                    value: 'fakeAccess',
                    expired: DateTime.now().add(const Duration(seconds: 300)),
                  ),
                  refreshToken: Token(
                    value: 'fakeRefresh',
                    expired: DateTime.now().add(const Duration(seconds: 300)),
                  ),
                  args: {
                    kSessionUserNameKey: 'user1',
                    kSessionUserPhotoKey: 'https://cdn.pixabay.com/photo/2014/04/03/11/56/avatar-312603_640.png',
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
                                      appBar: AppBar(),
                                      body: Center(
                                          child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                            return Scaffold(
                                              appBar: AppBar(),
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
                eventbus.broadcast(net.FirewallBlockEvent('BLOCK_SHORT'));
              }),
          ElevatedButton(
              child: const Text('no internet'),
              onPressed: () async {
                try {
                  throw const SocketException('wifi off');
                } catch (e) {
                  var contract = net.InternetRequiredEvent(exception: e, url: 'http://mock');
                  contract.isInternetConnected = () async {
                    return false;
                  };
                  await eventbus.broadcast(contract);
                }
              }),
          ElevatedButton(
              child: const Text('service not available'),
              onPressed: () async {
                var contract = net.InternetRequiredEvent(url: 'http://mock');
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
                var contract = net.InternetRequiredEvent(url: 'http://mock');
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
                eventbus.broadcast(net.InternalServerErrorEvent());
              }),
          ElevatedButton(
              child: const Text('server not ready'),
              onPressed: () {
                eventbus.broadcast(net.ServerNotReadyEvent());
              }),
          ElevatedButton(
              child: const Text('bad request'),
              onPressed: () {
                eventbus.broadcast(net.BadRequestEvent());
              }),
          ElevatedButton(
              child: const Text('client timeout'),
              onPressed: () async {
                try {
                  throw TimeoutException('client timeout');
                } catch (e) {
                  await eventbus.broadcast(net.RequestTimeoutEvent(isServer: false, exception: e, url: 'http://mock'));
                }
              }),
          ElevatedButton(
              child: const Text('deadline exceeded'),
              onPressed: () async {
                await eventbus.broadcast(net.RequestTimeoutEvent(isServer: true, url: 'http://mock'));
              }),
          ElevatedButton(
              child: const Text('slow network'), onPressed: () => eventbus.broadcast(net.SlowNetworkEvent())),
          ElevatedButton(child: const Text('disk error'), onPressed: () => throw preferences.DiskErrorException()),
        ],
      );
    }

    bar() {
      return Scaffold(
        appBar: Bar(
          home: const BarLogoButton(url: 'https://cryptologos.cc/logos/stacks-stx-logo.png'),
          items: [
            BarItemButton(text: 'Store', onPressed: () => debugPrint('store pressed')),
            BarItemButton(text: 'Mac', onPressed: () => debugPrint('Mac pressed')),
            BarItemButton(text: 'iPad', onPressed: () => debugPrint('iPad pressed')),
            BarItemButton(text: 'Watch', onPressed: () => debugPrint('Watch pressed')),
          ],
          actions: [
            BarUserButton(
              menuBuilder: () {
                return [
                  const PopupMenuItem(child: Text('Profile')),
                  const PopupMenuItem(child: Text('Sign out')),
                ];
              },
              onMenuSelected: (index) {
                debugPrint(index.toString());
              },
            ),
          ],
        ),
        body: Container(height: 1200, color: Colors.green),
        endDrawer: Drawer(
          shape: const RoundedRectangleBorder(),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(title: const Text('Home'), onTap: () => Navigator.pop(context)),
              ListTile(title: const Text('Mac'), onTap: () => Navigator.pop(context)),
              ListTile(title: const Text('iPad'), onTap: () => Navigator.pop(context)),
              ListTile(title: const Text('Watch'), onTap: () => Navigator.pop(context)),
            ],
          ),
        ),
        bottomNavigationBar: Footer(
          copyRight: const AutoSizeText('Copyright © 2023 Inc. All rights reserved.',
              maxLines: 2, style: TextStyle(fontSize: 12)),
          actions: const [LanguageButton()],
          items: [
            BarItemButton(text: 'Privacy Policy', onPressed: () => debugPrint('store pressed')),
            BarItemButton(text: 'Terms of Use', onPressed: () => debugPrint('Mac pressed')),
          ],
        ),
      );
    }

    sliverBar() {
      return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverBar(
                home: const BarLogoButton(url: 'https://cryptologos.cc/logos/stacks-stx-logo.png'),
                items: [
                  BarItemButton(text: 'Store', onPressed: () => debugPrint('store pressed')),
                  BarItemButton(text: 'Mac', onPressed: () => debugPrint('Mac pressed')),
                  BarItemButton(text: 'iPad', onPressed: () => debugPrint('iPad pressed')),
                  BarItemButton(text: 'Watch', onPressed: () => debugPrint('Watch pressed')),
                ],
                actions: [
                  BarUserButton(
                    menuBuilder: () {
                      return [
                        const PopupMenuItem(child: Text('Profile')),
                        const PopupMenuItem(child: Text('Sign out')),
                      ];
                    },
                    onMenuSelected: (index) {
                      debugPrint(index.toString());
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(child: Container(height: 1200, color: Colors.green)),
              SliverToBoxAdapter(
                  child: Footer(
                copyRight: const AutoSizeText('Copyright © 2023 Inc. All rights reserved.',
                    maxLines: 2, style: TextStyle(fontSize: 12)),
                actions: const [LanguageButton()],
                items: [
                  BarItemButton(text: 'Privacy Policy', onPressed: () => debugPrint('store pressed')),
                  BarItemButton(text: 'Terms of Use', onPressed: () => debugPrint('Mac pressed')),
                ],
              )),
            ],
          ),
          endDrawer: Drawer(
            shape: const RoundedRectangleBorder(),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(title: const Text('Home'), onTap: () => Navigator.pop(context)),
                ListTile(title: const Text('Mac'), onTap: () => Navigator.pop(context)),
                ListTile(title: const Text('iPad'), onTap: () => Navigator.pop(context)),
                ListTile(title: const Text('Watch'), onTap: () => Navigator.pop(context)),
              ],
            ),
          ));
    }

    preview() {
      String imgUrl =
          'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
      String imgUrl2 =
          'https://images.pexels.com/photos/13766623/pexels-photo-13766623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

      String videoUrl = 'https://download.samplelib.com/mp4/sample-5s.mp4';
      return Wrap(
        children: [
          SizedBox(width: 200, height: 150, child: PreviewImage(imgUrl)),
          SizedBox(width: 200, height: 200, child: PreviewQrImage(imgUrl)),
          ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 360,
                maxHeight: 240,
              ),
              child: PreviewVideo(videoUrl)),
          SizedBox(width: 200, height: 150, child: PreviewImage(imgUrl2)),
          AspectRatio(aspectRatio: 1125 / 750, child: PreviewImage(imgUrl)),
        ],
      );
    }

    return LoadingScreen(
      future: () async => await _load(context),
      builder: () => testing.ExampleScaffold(
        builder: sliverBar,
        buttons: [
          OutlinedButton(
            child: const Text('show alert use global context'),
            onPressed: () {
              dialog.alert('hello');
            },
          ),
          testing.ExampleButton('preview', builder: preview),
          testing.ExampleButton('Bar', useScaffold: false, builder: bar),
          testing.ExampleButton('SliverBar', useScaffold: false, builder: sliverBar),
          testing.ExampleButton('NavigationScaffold', useScaffold: false, builder: navigationScaffold),
          testing.ExampleButton('open web url', builder: tryOpenWebUrl),
          testing.ExampleButton('error screen', builder: errorScreen),
          testing.ExampleButton('goto', useScaffold: false, builder: goto),
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
        ],
      ),
    );
  }
}
