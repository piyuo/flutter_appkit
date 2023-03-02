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

  _trigger = SearchTrigger(
    controller: _searchBoxController,
    onSearch: (text) => debugPrint('search:$text'),
    onSearchBegin: () => debugPrint('search begin'),
    onSearchEnd: () => debugPrint('search end'),
  );

  app.start(
    theme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    ),
    routes: {
      '/': (context, state, data) => const DeltaExample(),
    },
  );
}

int errorCount = 0;

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final GlobalKey btnMenuOnBottom = GlobalKey();

final _checkController = ValueNotifier<bool>(false);

final _switchController = ValueNotifier<bool>(false);

final _segmentController = ValueNotifier<int>(0);

final _swipeController = ValueNotifier<int>(0);

final _busyController = ValueNotifier<bool>(false);

final _searchBoxController = TextEditingController();

final _scrollController = ScrollController();

SearchTrigger? _trigger;

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
                          child: _hypertext(context),
                        ),
                        SizedBox(
                          height: 100,
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: [
                                testing.ExampleButton(label: 'mounted pop', builder: () => _mounted(context)),
                                testing.ExampleButton(label: 'search trigger', builder: () => _searchTrigger(context)),
                                testing.ExampleButton(label: 'refresh more', builder: () => _refreshMoreView(context)),
                                testing.ExampleButton(label: 'button panel', builder: () => _buttonPanel(context)),
                                testing.ExampleButton(
                                    label: 'is touch enabled?', builder: () => _isTouchSupported(context)),
                                testing.ExampleButton(label: 'no data', builder: () => _noData(context)),
                                testing.ExampleButton(label: 'shimmer', builder: () => _shimmer(context)),
                                testing.ExampleButton(label: 'countdown', builder: () => _notificationBadge(context)),
                                testing.ExampleButton(label: 'countdown', builder: () => _countdown(context)),
                                testing.ExampleButton(label: 'search box', builder: () => _searchBox(context)),
                                testing.ExampleButton(label: 'redirect to url', builder: () => _redirectToUrl(context)),
                                testing.ExampleButton(
                                    label: 'tap on button hint', builder: () => _tapOnButtonHint(context)),
                                testing.ExampleButton(label: 'await on tap', builder: () => _awaitOnTap(context)),
                                testing.ExampleButton(label: 'refresh button', builder: () => _refreshButton(context)),
                                testing.ExampleButton(label: 'indicator', builder: () => _indicator(context)),
                                testing.ExampleButton(label: 'tap breaker', builder: () => _tapBreaker(context)),
                                testing.ExampleButton(label: 'web image', builder: () => _webImage(context)),
                                testing.ExampleButton(
                                    label: 'web image provider', builder: () => _webImageProvider(context)),
                                testing.ExampleButton(label: 'web image data', builder: () => _webImageData(context)),
                                testing.ExampleButton(label: 'checkbox', builder: () => _checkbox(context, model)),
                                testing.ExampleButton(label: 'hypertext', builder: () => _hypertext(context)),
                                testing.ExampleButton(label: 'menu button', builder: () => _menuButton(context)),
                                testing.ExampleButton(label: 'status light', builder: () => _statusLight(context)),
                                testing.ExampleButton(label: 'switch', builder: () => _switching(context)),
                                testing.ExampleButton(label: 'segment', builder: () => _segment(context)),
                                testing.ExampleButton(label: 'error', builder: () => _error(context)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Widget _mounted(BuildContext context) {
    return OutlinedButton(
      child: const Text('safely navigator pop'),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SecondRoute()),
      ),
    );
  }

  Widget _searchTrigger(BuildContext context) {
    return Column(children: [
      TextField(controller: _searchBoxController),
      ElevatedButton(
        child: const Text('dispose'),
        onPressed: () {
          if (_trigger != null) {
            _trigger!.dispose();
          }
        },
      )
    ]);
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
              onPressed: breaker.voidFunc(() async {
                await Future.delayed(const Duration(seconds: 2));
                debugPrint('break 1');
              }),
              child: const Text('break 1'),
            ),
            ElevatedButton(
              onPressed: breaker.voidFunc(() async {
                await Future.delayed(const Duration(seconds: 2));
                debugPrint('click 2');
              }),
              child: const Text('button2'),
            ),
          ]);
        }));
  }

  Widget _webImage(BuildContext context) {
    return Container(
        color: context.themeColor(
          light: Colors.grey.shade100,
          dark: Colors.grey.shade900,
        ),
        height: double.infinity,
        child: Wrap(
          children: [
            Image.network(
              'https://images.pexels.com/photos/7479003/pexels-photo-7479003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              width: 300,
              height: 300,
            ),
            WebImage(
              opacity: const AlwaysStoppedAnimation<double>(0.5),
              width: 300,
              height: 300,
              border: Border.all(color: Colors.red, width: 1),
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              'https://images.pexels.com/photos/7479003/pexels-photo-7479003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
            ),
            const WebImage(
              'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
              width: 300,
              height: 300,
            ),
            const SizedBox(width: 20),
            const WebImage(
              'https://not-exists',
              width: 300,
              height: 300,
            ),
            const WebImage(
              '',
              width: 300,
              height: 300,
            ),
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

  Widget _isTouchSupported(BuildContext context) {
    return context.isTouchSupported ? const Text('touch supported') : const Text('touch not support');
  }

  Widget _buttonPanel(BuildContext context) {
    return Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(50),
        child: ButtonPanel<String>(
          onPressed: (item) => debugPrint('$item pressed'),
          checkedValues: const ['1'],
          children: {
            '0': Row(children: const [
              Expanded(
                child: Text('button', style: TextStyle(fontSize: 18)),
              ),
              Icon(Icons.add),
            ]),
            '1': Row(children: const [
              Expanded(
                child: Text('button 1', style: TextStyle(fontSize: 18)),
              ),
              Icon(Icons.dark_mode),
            ]),
            '2': Row(children: const [
              Expanded(
                child: Text('button 2', style: TextStyle(fontSize: 18)),
              ),
              Icon(Icons.accessibility),
            ]),
          },
        ));
  }

  Widget _noData(BuildContext context) {
    return Column(
      children: const [
        NoDataDisplay(),
        Divider(),
        LoadingDisplay(),
      ],
    );
  }

  Widget _shimmer(BuildContext context) {
    return ShimmerScope(
        child: Column(children: [
      const SizedBox(width: 200, height: 100, child: Shimmer()),
      const Shimmer(width: 120, height: 30, radius: 15),
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

  Widget _notificationBadge(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: NotificationBadge(
            badgeText: '2',
            onBottom: true,
            child: Icon(Icons.shopping_bag, size: 24),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: NotificationBadge(
            badgeText: '22',
            onBottom: true,
            child: Icon(Icons.shopping_bag, size: 24),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: NotificationBadge(
            badgeText: '2',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: NotificationBadge(
            badgeText: '12',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: NotificationBadge(
            badgeText: '112',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Badge(
            backgroundColor: Colors.blue,
            //alignment: AlignmentDirectional(-1.0, -1.0),
            label: Text('xx', style: TextStyle(fontSize: 10)),
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
          child: SearchBox(
            controller: _searchBoxController,
            //prefixIcon: IconButton(icon: const Icon(Icons.menu), onPressed: () => debugPrint('menu pressed')),
          )),
      const Divider(),
      Padding(
          padding: const EdgeInsets.all(20),
          child: SearchBox(
            controller: _searchBoxController,
            prefixIcon: IconButton(icon: const Icon(Icons.menu), onPressed: () => debugPrint('menu pressed')),
            hintText: 'Search orders/products here',
            onSuggestion: (pattern) async {
              //             await Future.delayed(const Duration(seconds: 5));
              if (pattern == 'a') {
                return [SearchSuggestion('a', icon: Icons.add), SearchSuggestion('b'), SearchSuggestion('c')];
              }
              if (pattern == 'b') {
                return [];
              }
              return [SearchSuggestion('hello', icon: Icons.add), SearchSuggestion('world')];
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
        child: Hypertext(
          children: [
            const Span(text: 'click to print to console '),
            const Bold(text: 'click to print to console'),
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

  Widget _menuButton(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 40),
      const Text('General'),
      SizedBox(
        width: 140,
        child: MenuButton<String>(
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Settings'),
            onPressed: (value) {
              debugPrint('$value pressed');
            },
            selectedValue: '2',
            selection: const {
              '1': 'hello',
              '2': 'world',
            }),
      ),
      const Text('Disabled'),
      const MenuButton<String>(
        icon: Icon(Icons.settings),
        onPressed: null,
        selectedValue: '2',
        selection: {
          '1': 'hello',
          '2': 'world',
        },
      ),
    ]);
  }

  Widget _refreshMoreView(BuildContext context) {
    final List<String> items = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];
    //final List<String> items = <String>['A', 'B', 'C'];

    return RefreshMoreView(
      scrollController: _scrollController,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final String item = items[index];
        return ListTile(
          isThreeLine: true,
          leading: CircleAvatar(child: Text(item)),
          title: Text('This item represents $item.'),
          subtitle: const Text('Even more additional list item information appears on line three'),
        );
      },
      onRefresh: () async {
        debugPrint('refresh');
        await Future.delayed(const Duration(seconds: 5));
        debugPrint('refresh done');
      },
      onLoadMore: () async {
        debugPrint('more');
        await Future.delayed(const Duration(seconds: 3));
        debugPrint('more done');
      },
    );
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
    return ChangeNotifierProvider<RefreshButtonController>(
      create: (context) => RefreshButtonController(),
      child: Consumer<RefreshButtonController>(
          builder: (context, provide, child) => Column(children: [
                RefreshButton(onPressed: () async {
                  await Future.delayed(const Duration(seconds: 5));
                }),
                OutlinedButton(
                  onPressed: () async {
                    provide.value = true;
                    await Future.delayed(const Duration(seconds: 5));
                    provide.value = false;
                  },
                  child: const Text('refresh'),
                ),
              ])),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: Mounted(
          builder: (
            context,
            mounted,
          ) =>
              ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Go back!'),
          ),
        ),
      ),
    );
  }
}
