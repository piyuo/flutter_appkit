import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;

import '../delta.dart';

main() {
  _checkController.addListener(() {
    debugPrint('check controller:${_checkController.value}');
  });

  _segmentController.addListener(
    () => _swipeController.value = _segmentController.value,
  );

  _swipeController.addListener(
    () => _segmentController.value = _swipeController.value,
  );

  _searchBoxController.addListener(
    () => debugPrint(_searchBoxController.text),
  );

  app.start(
    appName: 'delta',
    routes: {
      '/': (context, state, data) => const DeltaExample(),
    },
  );
}

int errorCount = 0;

var _pullRefreshCount = 8;

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final GlobalKey btnMenuOnBottom = GlobalKey();

final _checkController = ValueNotifier<bool>(false);

final _switchController = ValueNotifier<bool>(false);

final _segmentController = ValueNotifier<int>(0);

final _swipeController = ValueNotifier<int>(0);

final _busyController = ValueNotifier<bool>(false);

final _searchBoxController = TextEditingController();

class DeltaExample extends StatelessWidget {
  const DeltaExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _checkController,
        child: Consumer<ValueNotifier<bool>>(
            builder: (context, model, child) => Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: _isMobile(context),
                        ),
                        Wrap(
                          children: [
                            testing.example(
                              context,
                              text: 'is mobile?',
                              child: _isMobile(context),
                            ),
                            testing.example(
                              context,
                              text: 'no data',
                              child: _noData(context),
                            ),
                            testing.example(
                              context,
                              text: 'place holder',
                              child: _placeHolder(context),
                            ),
                            testing.example(
                              context,
                              text: 'flicker',
                              child: _flicker(context),
                            ),
                            testing.example(
                              context,
                              text: 'wait',
                              child: _wait(context),
                            ),
                            testing.example(
                              context,
                              text: 'wait error',
                              child: _waitError(context),
                            ),
                            testing.example(
                              context,
                              text: 'countdown',
                              child: _badge(context),
                            ),
                            testing.example(
                              context,
                              text: 'countdown',
                              child: _countdown(context),
                            ),
                            testing.example(
                              context,
                              text: 'search box',
                              child: _searchBox(context),
                            ),
                            testing.example(
                              context,
                              text: 'redirect to url',
                              child: _redirectToUrl(context),
                            ),
                            testing.example(
                              context,
                              text: 'tap on button hint',
                              child: _tapOnButtonHint(context),
                            ),
                            testing.example(
                              context,
                              text: 'await on tap',
                              child: _awaitOnTap(context),
                            ),
                            testing.example(
                              context,
                              text: 'refresh button',
                              child: _refreshButton(context),
                            ),
                            testing.example(
                              context,
                              text: 'indicator',
                              child: _indicator(context),
                            ),
                            testing.example(
                              context,
                              text: 'tap breaker',
                              child: _tapBreaker(context),
                            ),
                            testing.example(
                              context,
                              text: 'web image',
                              child: _webImage(context),
                            ),
                            testing.example(
                              context,
                              text: 'web image provider',
                              child: _webImageProvider(context),
                            ),
                            testing.example(
                              context,
                              text: 'web image data',
                              child: _webImageData(context),
                            ),
                            testing.example(
                              context,
                              text: 'checkbox',
                              child: _checkbox(context, model),
                            ),
                            testing.example(
                              context,
                              text: 'hypertext',
                              child: _hypertext(context),
                            ),
                            testing.example(
                              context,
                              text: 'await wait',
                              child: _awaitWait(context),
                            ),
                            testing.example(
                              context,
                              text: 'await error',
                              child: _awaitError(context),
                            ),
                            testing.example(
                              context,
                              text: 'popup',
                              child: _popup(context),
                            ),
                            testing.example(
                              context,
                              text: 'menu button',
                              child: _menuButton(context),
                            ),
                            testing.example(
                              context,
                              text: 'pull refresh',
                              child: _pullRefresh(context),
                            ),
                            testing.example(
                              context,
                              text: 'pull refresh vertical',
                              child: _pullRefreshVertical(context),
                            ),
                            testing.example(
                              context,
                              text: 'status light',
                              child: _statusLight(context),
                            ),
                            testing.example(
                              context,
                              text: 'switch',
                              child: _switching(context),
                            ),
                            testing.example(
                              context,
                              text: 'segment',
                              child: _segment(context),
                            ),
                            testing.example(
                              context,
                              text: 'error',
                              child: _error(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Widget _redirectToUrl(BuildContext context) {
    return OutlinedButton(
      child: const Text('redirect to url'),
      onPressed: () => redirectToURL(context, 'https://starbucks.com', caption: 'starbucks.com'),
    );
  }

  Widget _tapOnButtonHint(BuildContext context) {
    return const TapOnButtonHint('Printer');
  }

  Widget _awaitOnTap(BuildContext context) {
    return AwaitOnTap(
      child: Row(children: const [
        Icon(Icons.menu),
        Text('hello'),
      ]),
      onAwaitTap: () async {
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('clicked');
      },
    );
  }

  Widget _tapBreaker(BuildContext context) {
    return ChangeNotifierProvider<TapBreaker>(
        create: (context) => TapBreaker(),
        child: Consumer<TapBreaker>(builder: (context, breaker, child) {
          return Row(children: [
            ElevatedButton(
              child: const Text('break 1'),
              onPressed: breaker.voidFunc(() async {
                await Future.delayed(const Duration(seconds: 2));
                debugPrint('break 1');
              }),
            ),
            ElevatedButton(
              child: const Text('button2'),
              onPressed: breaker.voidFunc(() async {
                await Future.delayed(const Duration(seconds: 2));
                debugPrint('click 2');
              }),
            ),
          ]);
        }));
  }

  Widget _webImage(BuildContext context) {
    return Container(
        color: context.themeColor(
          light: Colors.white,
          dark: Colors.black87,
        ),
        height: double.infinity,
        child: Row(
          children: const [
            SizedBox(
              width: 300,
              height: 300,
              child: WebImage(
                  'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000'),
            ),
            SizedBox(width: 20),
            SizedBox(
              width: 300,
              height: 300,
              child: WebImage(
                'https://not-really-exists',
              ),
            )
          ],
        ));
  }

  Widget _webImageProvider(BuildContext context) {
    final imageProvider = webImageProvider(
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000');

    return Container(
      decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
            image: imageProvider,
          )),
    );
  }

  Widget _webImageData(BuildContext context) {
    const url =
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000';

    return OutlinedButton(
      child: const Text('load image'),
      onPressed: () async {
        final bytes = await webImageData(url);
        if (bytes != null) {
          debugPrint('${bytes.length} loaded');
          return;
        }
        debugPrint('image not exists');
      },
    );
  }

  Widget _isMobile(BuildContext context) {
    return isMobile(context) ? const Text('mobile') : const Text('not mobile');
  }

  Widget _noData(BuildContext context) {
    return const NoData();
  }

  Widget _placeHolder(BuildContext context) {
    return Column(children: [
      PlaceHolder(builder: () => const Text('done')),
      const SizedBox(height: 20),
      Container(color: Colors.red, height: 30),
      /*
      const SizedBox(height: 20),
      Container(color: Colors.red, height: 30),
      const SizedBox(height: 20),
      const SizedBox(height: 20),
      PlaceHolder(width: 120, height: 30, builder: () => const Text('done')),
      */
    ]);
  }

  Widget _flicker(BuildContext context) {
    return Flicker(
        child: Column(children: [
      PlaceHolder(width: 120, height: 30, builder: () => const Text('done')),
      const SizedBox(height: 20),
      PlaceHolder(width: 120, height: 30, builder: () => const Text('done')),
      const SizedBox(height: 20),
      FittedBox(
          child: Icon(
        Icons.image,
        size: 120,
        color: context.themeColor(
          dark: Colors.grey.shade800,
          light: Colors.grey.shade400,
        ),
      )),
    ]));
  }

  Widget _wait(BuildContext context) {
    return Wait<String>(
      waitFor: () async {
        await Future.delayed(const Duration(seconds: 3));
        return 'hello world';
      },
      builder: (context, text) => Text(text ?? 'no data'),
    );
  }

  Widget _waitError(BuildContext context) {
    return Wait<String>(
      waitFor: () async {
        await Future.delayed(const Duration(seconds: 3));
        if (errorCount <= 1) {
          errorCount++;
          throw Exception('error');
        }
      },
      builder: (context, text) => Text(text ?? 'no data'),
    );
  }

  Widget _badge(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: Badge(
            badgeContent: '2',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Badge(
            badgeContent: '12',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Badge(
            badgeContent: '112',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Badge(
            child: Text('Empty', style: TextStyle(fontSize: 20)),
          ),
        )
      ],
    );
  }

  Widget _countdown(BuildContext context) {
    return Column(
      children: const [
        CountUp(
          greenLight: 10,
          yellowLight: 20,
        ),
        CountDown(
          duration: Duration(minutes: 0, seconds: 10),
        )
      ],
    );
  }

  Widget _searchBox(BuildContext context) {
    var controller1 = TextEditingController();
    var focusNode1 = FocusNode();
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(20),
          child: SearchBox<String>(
            controller: _searchBoxController,
            hintText: 'Search orders/products here',
            suggestionsCallback: (pattern) async {
//            await Future.delayed(const Duration(seconds: 5));
              if (pattern == 'a') {
                return ['a', 'b', 'c'];
              }
              if (pattern == 'b') {
                return [];
              }
              return ['hello', 'world'];
            },
          )),
      const Divider(),
      Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  child: const Text('set text'),
                  onPressed: () {
                    controller1.text = 'hello world';
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  child: const Text('show suggestion'),
                  onPressed: () {
                    focusNode1.requestFocus();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                  child: const Text('hide suggestion'),
                  onPressed: () {
                    focusNode1.unfocus();
                  }),
            ),
            SearchBar(
              controller: controller1,
              focusNode: focusNode1,
              hint: 'please enter search text',
              suggestionBuilder: (text) async {
                if (text == '') {
                  return [
                    'selection 1',
                    'selection 2',
                    'selection 3',
                  ];
                }

                return [
                  'aa',
                  'bb',
                  'cc',
                ];
              },
              onSuggestionChanged: (text) => debugPrint('1. $text selected'),
              onTextChanged: (text) => debugPrint('1. text changed: $text'),
            ),
            const SizedBox(height: 20),
            const Text('no suggestion'),
            SearchBar(
              controller: TextEditingController(),
              onTextChanged: (text) => debugPrint('2.text changed: $text'),
            ),
            const Text('text not empty suggestion'),
            SearchBar(
              controller: TextEditingController(),
              suggestionBuilder: (text) async {
                if (text == '') {
                  return [];
                }

                return [
                  'aa',
                  'bb',
                  'cc',
                ];
              },
              onTextChanged: (text) => debugPrint('3.text changed: $text'),
            ),
            const Text('not dense'),
            SearchBar(
              controller: TextEditingController(text: 'search now'),
              isDense: false,
            ),
          ])),
    ]);
  }

  Widget _checkbox(BuildContext context, ValueNotifier model) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('RoundCheckbox', style: TextStyle(fontWeight: FontWeight.bold)),
            RoundCheckbox(
              checked: model.value,
              onChanged: (v) => model.value = v,
            ),
            const SizedBox(height: 20),
            const Text('CheckboxLabel', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxLabel(
              label: 'checkbox label',
              checked: model.value,
              onChanged: (v) => model.value = v,
            ),
            const Text('disabled', style: TextStyle(fontWeight: FontWeight.bold)),
            CheckboxLabel(
              label: 'disabled checkbox',
              checked: model.value,
            ),
            const SizedBox(height: 20),
            const Text('check', style: TextStyle(fontWeight: FontWeight.bold)),
            Check(
              label: 'Remember me',
              controller: _checkController,
            ),
            const SizedBox(width: 20),
            const Text('style', style: TextStyle(fontWeight: FontWeight.bold)),
            Check(
              checkColor: Colors.red,
              fillColor: Colors.green,
              controller: _checkController,
            ),
            const SizedBox(width: 20),
            Check(
              disabled: true,
              label: 'disabled',
              checkColor: Colors.red,
              fillColor: Colors.green,
              controller: _checkController,
            ),
          ],
        ));
  }

  Widget _hypertext(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Hypertext(fontSize: 13)
        ..span('click to print to console')
        ..action('privacy', onTap: (_, __) => debugPrint('hello world'))
        ..span('click to open url')
        ..link('starbucks', url: 'https://www.starbucks.com'),
    );
  }

  Widget _awaitError(BuildContext context) {
    return TextButton(
      child: const Text('provider with problem'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const WrongPage();
        }));
      },
    );
  }

  Widget _awaitWait(BuildContext context) {
    return TextButton(
      child: const Text('provider need wait 30\'s'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const WaitPage();
        }));
      },
    );
  }

  Widget _switching(BuildContext context) {
    return Switching(controller: _switchController);
  }

  Widget _segment(BuildContext context) {
    return Column(children: [
      SlideSegment<int>(
        onBeforeChange: (index) {
          debugPrint('before change: $index');
        },
        controller: _segmentController,
        children: const {
          0: Text('Network Printer'),
          1: Text('Bluetooth Printer'),
        },
      ),
      Segment<int>(
        onBeforeChange: (index) {
          debugPrint('before change: $index');
        },
        controller: _segmentController,
        children: const {
          0: Text('Network Printer'),
          1: Text('Bluetooth Printer'),
        },
      ),
      SizedBox(
          height: 200,
          child: SwipeContainer(controller: _swipeController, children: const [
            Text('Network Setting'),
            Text('Bluetooth Setting'),
          ])),
      SizedBox(
        height: 200,
        child: SegmentContainer(
            segmentControl: Segment<int>(
              onBeforeChange: (index) {
                debugPrint('before change: $index');
              },
              controller: _swipeController,
              children: const {
                0: Text('Network Printer'),
                1: Text('Bluetooth Printer'),
              },
            ),
            controller: _swipeController,
            children: const [
              Text('hello Network Setting'),
              Text('hello Bluetooth Setting'),
            ]),
      ),
      SizedBox(
        height: 200,
        child: SegmentContainer(
            segmentControl: SlideSegment<int>(
              onBeforeChange: (index) {
                debugPrint('before change: $index');
              },
              controller: _swipeController,
              children: const {
                0: Text('Network Printer'),
                1: Text('Bluetooth Printer'),
              },
            ),
            controller: _swipeController,
            children: const [
              Text('hello Network Setting'),
              Text('hello Bluetooth Setting'),
            ]),
      ),
    ]);
  }

  Widget _error(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: Column(children: const [
          // Separator(height: 2, color: Colors.red.shade200),
          SizedBox(height: 30),
          ErrorLabel(
            message: 'An error message is information displayed when an unforeseen problem occurs',
          ),
          SizedBox(height: 30),
          ErrorBox(
              message:
                  'An error message is information displayed when an unforeseen problem occurs, usually on a computer or other device. On modern operating systems with graphical, error messages are often displayed using dialog boxes. Error messages are used when user intervention is required, to indicate that a desired operation has failed, or to relay important warnings (such as warning a computer user that they are almost out of hard disk space). Error messages are seen widely throughout computing, and are part of every operating system or computer hardware device. Proper design of error messages is an important topic in usability and other fields of human–computer interaction'),
        ]));
  }

  Widget _popup(BuildContext context) {
    final GlobalKey btnPopup = GlobalKey();
    return ElevatedButton(
      key: btnPopup,
      child: const Text('popup'),
      onPressed: () {
        var rect = getWidgetGlobalRect(btnPopup);
        popup(context,
            rect: Rect.fromLTWH(rect.left, rect.bottom, rect.width, 200),
            child: Container(
              color: Colors.green,
              child: Center(
                  child: InkWell(
                onTap: () => debugPrint('hello'),
                child: const Text(
                  'hello',
                  style: TextStyle(fontSize: 22),
                ),
              )),
            ));
      },
    );
  }

  Widget _menuButton(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 40),
      const Text('General'),
      Row(
        children: [
          const SizedBox(width: 20),
          const Text('Settings'),
          MenuButton<String>(
              icon: const Icon(Icons.settings),
              onPressed: (value) {
                debugPrint('$value pressed');
              },
              checkedValue: '2',
              selection: const {
                '1': 'hello',
                '2': 'world',
              })
        ],
      ),
    ]);
  }

  Widget _pullRefresh(BuildContext context) {
    return SizedBox(
        height: 200,
        child: PullRefresh(
            scrollDirection: Axis.horizontal,
            onPullRefresh: (BuildContext context) async {
              await Future.delayed(const Duration(seconds: 1));
              _pullRefreshCount--;
            },
            onLoadMore: (BuildContext context) async {
              await Future.delayed(const Duration(seconds: 1));
              _pullRefreshCount++;
            },
            itemCount: (BuildContext context) {
              return _pullRefreshCount;
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 100,
                height: 100,
                color: index % 2 == 0 ? Colors.yellow[100] : Colors.blue[100],
                margin: const EdgeInsets.all(0),
                child: Text('item $index'),
              );
            }));
  }

  Widget _pullRefreshVertical(BuildContext context) {
    return PullRefresh(onPullRefresh: (BuildContext context) async {
      await Future.delayed(const Duration(seconds: 1));
      _pullRefreshCount--;
    }, onLoadMore: (BuildContext context) async {
      await Future.delayed(const Duration(seconds: 1));
      _pullRefreshCount++;
    }, itemCount: (BuildContext context) {
      return _pullRefreshCount;
    }, itemBuilder: (BuildContext context, int index) {
      return Container(
        //height: double.infinity,
        color: Colors.blue[100],
        padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
        child: Text('item $index'),
      );
    });
  }

  Widget _statusLight(BuildContext context) {
    return Row(children: const [
      Expanded(
        child: StatusLight(status: LightStatus.green, tooltip: 'connected', label: 'connected'),
      ),
      SizedBox(
        width: 120,
        child: StatusLight(status: LightStatus.yellow, tooltip: 'connecting..', label: 'connecting..'),
      ),
      SizedBox(
        width: 120,
        child: StatusLight(status: LightStatus.red, tooltip: 'failed to connect', label: 'failed to connect'),
      ),
    ]);
  }

  Widget _indicator(BuildContext context) {
    return Column(children: [
      Busy(
        controller: _busyController,
      ),
      OutlinedButton(
        child: const Text('toggle busy'),
        onPressed: () {
          _busyController.value = !_busyController.value;
        },
      ),
      SizedBox(width: 100, height: 20, child: ballPulseIndicator()),
      SizedBox(width: 100, height: 20, child: ballSyncIndicator()),
      SizedBox(width: 100, height: 100, child: ballScaleIndicator()),
      SizedBox(width: 100, height: 50, child: lineScaleIndicator()),
      SizedBox(width: 100, height: 100, child: ballSpinIndicator()),
    ]);
  }

  Widget _refreshButton(BuildContext context) {
    return ChangeNotifierProvider<RefreshButtonProvider>(
      create: (context) => RefreshButtonProvider(),
      child: Consumer<RefreshButtonProvider>(
          builder: (context, provide, child) => Column(children: [
                RefreshButton(
                    size: 32,
                    color: Colors.blue,
                    onPressed: () async {
                      await Future.delayed(const Duration(seconds: 5));
                    }),
                OutlinedButton(
                  onPressed: () async {
                    provide.setBusy(true);
                    await Future.delayed(const Duration(seconds: 5));
                    provide.setBusy(false);
                  },
                  child: const Text('refresh'),
                ),
              ])),
    );
  }
}

class WaitProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 30));
  }
}

class WaitPage extends StatelessWidget {
  const WaitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WaitProvider>(
        create: (context) => WaitProvider(),
        child: Consumer<WaitProvider>(
            builder: (context, provide, child) => Await(
                  [provide],
                  child: Container(),
                )));
  }
}

class WrongProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    throw Exception('load error');
  }
}

class WrongPage extends StatelessWidget {
  const WrongPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WrongProvider>(
        create: (context) => WrongProvider(),
        child: Consumer<WrongProvider>(
            builder: (context, provide, child) => Await(
                  [provide],
                  child: Container(),
                )));
  }
}
