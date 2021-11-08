import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;

import '../delta.dart';

main() {
  _checkController.addListener(() {
    debugPrint('check controller:${_checkController.value}');
  });
  _listingController.addListener(
    () => debugPrint(_listingController.value.toString()),
  );

  app.start(
    appName: 'delta example',
    routes: (_) => const DeltaExample(),
  );
}

var _pullRefreshCount = 8;

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final GlobalKey btnMenuOnBottom = GlobalKey();

final _listingController = ValueNotifier<int>(1);

final _checkListController = ValueNotifier<List<int>>([]);

final _checkController = ValueNotifier<bool>(false);

final _switchController = ValueNotifier<bool>(false);

class DeltaExample extends StatelessWidget {
  const DeltaExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _checkController,
        child: Consumer<ValueNotifier<bool>>(
            builder: (context, model, child) => Scaffold(
                  body: SafeArea(
                    child: Wrap(
                      children: [
                        SizedBox(
                          height: 400,
                          child: _checkList(context),
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
                          text: 'search_bar',
                          child: _searchBar(context),
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
                          text: 'listing',
                          child: _listing(context),
                        ),
                        testing.example(
                          context,
                          text: 'check list',
                          child: _checkList(context),
                        ),
                        testing.example(
                          context,
                          text: 'menu',
                          child: _menu(context),
                        ),
                        testing.example(
                          context,
                          text: 'menu on bottom',
                          child: _menuOnBottom(context),
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
                          text: 'ask permission',
                          child: _askPermission(context),
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
                      ],
                    ),
                  ),
                )));

    ;
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
              onPressed: breaker.linkVoidFunc(() async {
                await Future.delayed(const Duration(seconds: 2));
                debugPrint('break 1');
              }),
            ),
            ElevatedButton(
              child: const Text('button2'),
              onPressed: breaker.linkVoidFunc(() async {
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

  Widget _searchBar(BuildContext context) {
    var controller1 = TextEditingController();
    var focusNode1 = FocusNode();
    return Padding(
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
        ]));
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

  Widget _checkList(BuildContext context) {
    return CheckList(
//      selectedTileColor: Colors.grey[300],
      //     checkboxColor: Colors.grey,
      controller: _checkListController,
      onItemTap: (int key) {
        debugPrint('item $key tapped');
      },
      items: [
        ListItem(
          1,
          title: 'item 1',
          icon: Icons.print,
          iconColor: Colors.green,
        ),
        ListItem(
          2,
          title: 'item 2',
          icon: Icons.access_alarms_sharp,
          iconColor: Colors.green,
        ),
        ListItem(
          3,
          title: 'item 3',
          icon: Icons.air,
          iconColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _listing(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 300,
            height: 300,
            child: Listing<int>(
              dividerColor: Colors.grey,
              controller: ValueNotifier<int>(0),
              items: [
                ListItem(1, title: 'item 1'),
                ListItem(7, title: 'item 7'),
                ListItem(8, title: 'item 8'),
                ListItem(9, title: 'item 9'),
                ListItem(0, title: 'item 0'),
              ],
              onItemTap: (context, int key) {
                debugPrint('$key pressed');
              },
            )),
        SizedBox(
            width: 300,
            height: 300,
            child: Listing<int>(
              controller: _listingController,
              shape: Shape.roundRight,
              selectedTileColor: Colors.green[400],
              selectedFontColor: Colors.grey[100],
              fontColor: Colors.green[600],
              physics: const NeverScrollableScrollPhysics(),
              items: [
                ListItem(1, title: 'item 1'),
                ListItem(2, title: 'item 2', icon: Icons.card_giftcard),
                const Divider(
                  height: 1,
                ),
                ListItem(3, title: 'item 3', icon: Icons.card_giftcard, iconColor: Colors.red),
                ListItem(4, title: 'item 4', icon: Icons.card_giftcard),
                ListItem(5, title: 'item 5', icon: Icons.card_giftcard),
                ListItem(6, title: 'item 6', icon: Icons.card_giftcard),
                ListItem(7, title: 'item 7'),
                ListItem(8, title: 'item 8'),
                ListItem(9, title: 'item 9'),
                ListItem(0, title: 'item 0'),
              ],
              tileBuilder: (BuildContext context, int key, dynamic item, bool selected) {
                return key == 1
                    ? Container(
                        height: 100,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            item is ListItem ? item.title ?? '' : '',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ))
                    : null;
              },
              onItemTap: (context, int key) {
                debugPrint('$key pressed');
              },
            )),
        SizedBox(
            width: 300,
            height: 300,
            child: Listing<int>(
              controller: _listingController,
              dense: true,
              padding: EdgeInsets.zero,
              shape: Shape.round,
              items: [
                ListItem(1, title: 'item 1'),
                ListItem(2, title: 'item 2'),
                ListItem(3, title: 'item 3'),
                ListItem(4, title: 'item 4'),
                ListItem(5, title: 'item 5'),
                ListItem(6, title: 'item 6'),
              ],
              textBuilder: (BuildContext context, int key, String text, bool selected) {
                return key == 5
                    ? Text(
                        text,
                        style: const TextStyle(color: Colors.red),
                      )
                    : null;
              },
              onItemTap: (context, int key) {
                debugPrint('$key pressed');
              },
            )),
        Expanded(
          child: Container(
            color: Colors.yellow,
            height: 300,
          ),
        ),
      ],
    );
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

  Widget _menu(BuildContext context) {
    return SizedBox(
        width: 240,
        child: ElevatedButton(
          key: btnMenu,
          child: const Text('menu'),
          onPressed: () async {
            int? i = await menu<int>(
              context,
              target: btnMenu,
              items: [
                ListItem(1, title: 'item 1'),
                ListItem(2, title: 'item 2'),
                ListItem(3, title: 'item 3'),
              ],
            );
            debugPrint(i != null ? 'select item $i' : 'not select');
          },
        ));
  }

  Widget _menuOnBottom(BuildContext context) {
    return Container(
        alignment: Alignment.bottomLeft,
        height: 500,
        width: 240,
        child: ElevatedButton(
          key: btnMenuOnBottom,
          child: const Text('menu on bottom'),
          onPressed: () async {
            int? i = await menu<int>(
              context,
              target: btnMenuOnBottom,
              items: [
                ListItem(1, title: 'item 1'),
                ListItem(2, title: 'item 2'),
                ListItem(3, title: 'item 3'),
              ],
            );
            debugPrint(i != null ? 'select item $i' : 'not select');
          },
        ));
  }

  Widget _pullRefresh(BuildContext context) {
    return PullRefresh(
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
        });
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

  Widget _askPermission(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            child: const Text('bluetooth permission'),
            onPressed: () async {
              var result = await askBluetoothPermission(context);
              debugPrint(result ? 'got permission' : 'denied');
            }),
        OutlinedButton(
            child: const Text('camera permission'),
            onPressed: () async {
              var result = await askCameraPermission(context);
              debugPrint(result ? 'got permission' : 'denied');
            }),
        OutlinedButton(
            child: const Text('photo permission'),
            onPressed: () async {
              var result = await askPhotoPermission(context);
              debugPrint(result ? 'got permission' : 'denied');
            }),
        OutlinedButton(
            child: const Text('location permission'),
            onPressed: () async {
              var result = await askLocationPermission(context);
              debugPrint(result ? 'got permission' : 'denied');
            }),
        OutlinedButton(
            child: const Text('notification permission'),
            onPressed: () async {
              var result = await askNotificationPermission(context);
              debugPrint(result ? 'got permission' : 'denied');
            }),
        OutlinedButton(
            child: const Text('microphone permission'),
            onPressed: () async {
              var result = await askMicrophonePermission(context);
              debugPrint(result ? 'got permission' : 'denied');
            }),
      ],
    );
  }

  Widget _statusLight(BuildContext context) {
    return Row(children: const [
      StatusLight(status: 1, tooltip: 'connected'),
      SizedBox(width: 20),
      StatusLight(status: 0, tooltip: 'connecting..'),
      SizedBox(width: 20),
      StatusLight(status: -1, tooltip: 'failed to connect'),
    ]);
  }

  Widget _indicator(BuildContext context) {
    return Column(children: [
      SizedBox(width: 100, height: 20, child: ballPulseIndicator()),
      SizedBox(width: 100, height: 20, child: ballSyncIndicator()),
      SizedBox(width: 100, height: 100, child: ballScaleIndicator()),
      SizedBox(width: 100, height: 50, child: lineScaleIndicator()),
      SizedBox(width: 100, height: 100, child: lineSpinIndicator()),
    ]);
  }

  Widget _refreshButton(BuildContext context) {
    return RefreshButton(
        iconSize: 48,
        onRefresh: (BuildContext context) async {
          await Future.delayed(const Duration(seconds: 5));
        });
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
