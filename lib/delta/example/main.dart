import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/dialog/dialog.dart' as dialog;
import '../delta.dart';

final _listingController = ValueNotifier<int>(1);

final _checkListController = ValueNotifier<List<int>>([]);

final _sidePanelProvider = SidePanelProvider();

var _scrollController = ScrollController();

final GlobalKey<AnimateGridState> _gridKey = GlobalKey<AnimateGridState>();

var _gridItems = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

int _gridIndex = 10;

Widget _itemBuilder(bool isListView, int index) {
  int item = _gridItems[index];
  if (isListView) {
    return SizedBox(
      // Actual widget to display
      height: 64.0,
      child: Card(
        child: Center(
          child: Text('Item $item'),
        ),
      ),
    );
  }
  return Card(
    child: Center(
      child: Text('grid item $item'),
    ),
  );
}

main() {
  _listingController.addListener(
    () => debugPrint(_listingController.value.toString()),
  );

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
    onSearch: (text) => debugPrint('searchX:$text'),
    onSearchBegin: () => debugPrint('search begin'),
    onSearchEnd: () => debugPrint('search end'),
  );

  base.start(
    theme: testing.theme(),
    darkTheme: testing.darkTheme(),
    routesBuilder: () => {
      '/': (context, _, __) => dialog.cupertinoBottomSheet(const DeltaExample()),
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

SearchTrigger? _trigger;

class DeltaExample extends StatefulWidget {
  const DeltaExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeltaExampleState();
}

class _DeltaExampleState extends State<DeltaExample> {
  int shifterIndex = 1;
  bool shifterReverse = false;
  bool shifterVertical = false;

  bool isSwitched = false;

  int counter = 3;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: _checkController),
        ],
        child: Consumer<ValueNotifier<bool>>(
            builder: (context, model, child) => Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          //child: SingleChildScrollView(child: _barView(context)),
                          child: _expansionDrawer(context),
                        ),
                        SizedBox(
                          height: 100,
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: [
                                testing.ExampleButton(
                                    label: 'BarView', useScaffold: false, builder: () => _barView(context)),
                                testing.ExampleButton(label: 'preview', builder: () => _preview(context)),
                                testing.ExampleButton(label: 'chat bubble', builder: () => _chatBubble(context)),
                                testing.ExampleButton(
                                    label: 'ExpansionPanel', builder: () => _expansionDrawer(context)),
                                testing.ExampleButton(label: 'mounted pop', builder: () => _mounted(context)),
                                testing.ExampleButton(label: 'search trigger', builder: () => _searchTrigger(context)),
                                testing.ExampleButton(
                                    label: 'is touch enabled?', builder: () => _isTouchSupported(context)),
                                testing.ExampleButton(label: 'no data', builder: () => _noData(context)),
                                testing.ExampleButton(label: 'shimmer', builder: () => _shimmer(context)),
                                testing.ExampleButton(label: 'AnimatedBadge', builder: () => _animatedBadge(context)),
                                testing.ExampleButton(label: 'countdown', builder: () => _countdown(context)),
                                testing.ExampleButton(label: 'search box', builder: () => _searchBox(context)),
                                testing.ExampleButton(label: 'refresh button', builder: () => _refreshButton(context)),
                                testing.ExampleButton(label: 'indicator', builder: () => _indicator(context)),
                                testing.ExampleButton(label: 'tap breaker', builder: () => _tapBreaker(context)),
                                testing.ExampleButton(label: 'qr image', builder: () => _qrImage(context)),
                                testing.ExampleButton(label: 'web image', builder: () => _webImage(context)),
                                testing.ExampleButton(label: 'single image', builder: () => _singleImage(context)),
                                testing.ExampleButton(label: 'web video', builder: () => _webVideo(context)),
                                testing.ExampleButton(label: 'checkbox', builder: () => _checkbox(context, model)),
                                testing.ExampleButton(label: 'status light', builder: () => _statusLight(context)),
                                testing.ExampleButton(label: 'switch', builder: () => _switching(context)),
                                testing.ExampleButton(label: 'segment', builder: () => _segment(context)),
                                testing.ExampleButton(label: 'error label', builder: () => _errorLabel(context)),
                                testing.ExampleButton(label: 'side panel', builder: () => _sidePanel(context)),
                                testing.ExampleButton(label: 'listing', builder: () => _listing(context)),
                                testing.ExampleButton(label: 'check list', builder: () => _checkList(context)),
                                testing.ExampleButton(
                                    label: 'VerticalOnPhoneLayout', builder: () => _verticalOnPhoneLayout(context)),
                                testing.ExampleButton(
                                    label: 'padding to center', builder: () => _paddingToCenter(context)),
                                testing.ExampleButton(
                                    label: 'wrapped-list-view', builder: () => _wrappedListView(context)),
                                testing.ExampleButton(label: 'responsive', builder: () => _responsive(context)),
                                testing.ExampleButton(
                                  label: 'shifter',
                                  builder: () => _shifter(context),
                                ),
                                testing.ExampleButton(
                                  label: 'AnimateSliverList',
                                  builder: () => _animateSliverList(context),
                                ),
                                testing.ExampleButton(
                                  label: 'animated grid',
                                  builder: () => _animatedGrid(context),
                                ),
                                testing.ExampleButton(
                                  label: 'animated view in list',
                                  builder: () => _animatedViewInList(context),
                                ),
                                testing.ExampleButton(
                                  label: 'animated view in grid',
                                  builder: () => _animatedViewInGrid(),
                                ),
                                testing.ExampleButton(
                                  label: 'animated view in list view',
                                  builder: () => _animatedViewInListView(context),
                                ),
                                testing.ExampleButton(
                                  label: 'axis animate',
                                  builder: () => _axisAnimate(context),
                                ),
                                testing.ExampleButton(
                                  label: 'transform container',
                                  builder: () => _transformContainer(context),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }

  Widget _shifter(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          OutlinedButton(
              child: const Text('left in'),
              onPressed: () {
                setState(() {
                  shifterVertical = false;
                  shifterReverse = false;
                  shifterIndex++;
                });
              }),
          OutlinedButton(
              child: const Text('right in'),
              onPressed: () {
                setState(() {
                  shifterVertical = false;
                  shifterReverse = true;
                  shifterIndex--;
                });
              }),
          OutlinedButton(
              child: const Text('bottom in'),
              onPressed: () {
                setState(() {
                  shifterVertical = true;
                  shifterReverse = false;
                  shifterIndex++;
                });
              }),
          OutlinedButton(
              child: const Text('top in'),
              onPressed: () {
                setState(() {
                  shifterVertical = true;
                  shifterReverse = true;
                  shifterIndex--;
                });
              }),
        ]),
        Shifter(
          reverse: shifterReverse,
          vertical: shifterVertical,
          newChildKey: ValueKey(shifterIndex),
          child: shifterIndex == 1
              ? Container(
                  key: ValueKey(shifterIndex),
                  width: 200,
                  height: 400,
                  color: Colors.red,
                  child: const Text('text 1'),
                )
              : shifterIndex == 2
                  ? Container(
                      key: ValueKey(shifterIndex),
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                      child: const Text('text 2'))
                  : Container(
                      key: ValueKey(shifterIndex),
                      width: 200,
                      height: 200,
                      color: Colors.green,
                      child: const Text('text 3')),
        ),
      ],
    );
  }

  Widget slideIt(BuildContext context, int index, animation) {
    int item = _gridItems[index];
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: const Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
        // Actual widget to display
        height: 128.0,
        child: Card(
          child: Center(
            child: Text('Item $item'),
          ),
        ),
      ),
    );
  }

  Widget _animateSliverList(BuildContext context) {
    return CustomScrollView(slivers: [
      AnimateSliverList(
          itemCount: 20,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Item $index'),
            );
          }),
    ]);
  }

  Widget _animatedGrid(BuildContext context) {
    return Column(children: [
      Row(children: [
        OutlinedButton(
          child: const Text('insert'),
          onPressed: () {
            _gridItems.insert(0, _gridIndex++);
            _gridKey.currentState!.insertItem(0);
          },
        ),
        OutlinedButton(
            child: const Text('remove'),
            onPressed: () {
              _gridKey.currentState!.removeItem(1, (_, animation) => slideIt(context, 0, animation));
              _gridItems.removeAt(1);
            }),
      ]),
      Expanded(
          child: AnimateGrid(
        key: _gridKey,
        mainAxisSpacing: 5,
        crossAxisSpacing: 20,
        crossAxisCount: 2,
        initialItemCount: _gridItems.length,
        itemBuilder: (context, index, animation) {
          return slideIt(context, index, animation); // Refer step 3
        },
      )),
    ]);
  }

  Widget _axisAnimate(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
            child: const Text('horizontal animation'),
            onPressed: () {
              setState(() {
                isSwitched = !isSwitched;
              });
            }),
        SizedBox(
          width: 200,
          height: 200,
          child: AxisAnimation(
            reverse: isSwitched,
            child: isSwitched
                ? Container(key: UniqueKey(), width: 200, height: 200, color: Colors.red)
                : Container(key: UniqueKey(), width: 200, height: 200, color: Colors.blue),
          ),
        ),
        OutlinedButton(
            child: const Text('vertical animation'),
            onPressed: () {
              setState(() {
                isSwitched = !isSwitched;
              });
            }),
        SizedBox(
          width: 200,
          height: 200,
          child: AxisAnimation(
            type: AxisAnimationType.vertical,
            reverse: isSwitched,
            child: isSwitched
                ? Container(key: UniqueKey(), width: 200, height: 200, color: Colors.red)
                : Container(key: UniqueKey(), width: 200, height: 200, color: Colors.blue),
          ),
        ),
        OutlinedButton(
            child: const Text('scale animation'),
            onPressed: () {
              setState(() {
                isSwitched = !isSwitched;
              });
            }),
        SizedBox(
          width: 200,
          height: 200,
          child: AxisAnimation(
            type: AxisAnimationType.scaled,
            reverse: isSwitched,
            child: isSwitched
                ? Container(key: UniqueKey(), width: 100, height: 100, color: Colors.red)
                : Container(key: UniqueKey(), width: 200, height: 200, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _transformContainer(BuildContext context) {
    return TransformContainer(
        closedBuilder: (_, openContainer) {
          return OutlinedButton(
            onPressed: openContainer,
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
        closedColor: Colors.blue,
        openBuilder: (_, closeContainer) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text("Details"),
              leading: IconButton(
                onPressed: closeContainer,
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            body: (ListView.builder(
                itemCount: 10,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(index.toString()),
                  );
                })),
          );
        });
  }

  Widget _animatedViewInList(BuildContext context) {
    return ChangeNotifierProvider<AnimateViewProvider>(
      create: (context) => AnimateViewProvider()..setLength(_gridItems.length),
      child: Consumer<AnimateViewProvider>(
          builder: (context, provide, child) => Column(children: [
                Row(children: [
                  OutlinedButton(
                    child: const Text('update item count'),
                    onPressed: () {
                      provide.setLength(5);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('shake'),
                    onPressed: () {
                      provide.shakeAnimation(2);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('insert'),
                    onPressed: () {
                      _gridItems.insert(0, 9);
                      provide.insertAnimation(index: 0, duration: const Duration(milliseconds: 500));
                    },
                  ),
                  OutlinedButton(
                      child: const Text('remove'),
                      onPressed: () async {
                        Widget removedItem = _itemBuilder(true, 2);
                        _gridItems.removeAt(2);
                        provide.removeAnimation(2, removedItem);
                        await provide.waitForAnimationDone();
                        debugPrint('animation done');
                      }),
                  OutlinedButton(
                    child: const Text('reorder'),
                    onPressed: () {
                      Widget removedItem = _itemBuilder(true, 2);
                      _gridItems.removeAt(2);
                      provide.removeAnimation(2, removedItem);
                      _gridItems.insert(0, 2);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                    child: const Text('next page'),
                    onPressed: () {
                      _gridItems = [11, 12, 13];

                      provide.nextPageAnimation(3);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('prev page'),
                    onPressed: () {
                      _gridItems = [21, 22, 23, 24, 25];
                      provide.prevPageAnimation(5);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('refresh'),
                    onPressed: () {
                      _gridItems = [31, 32, 33, 34, 35];
                      provide.refreshPageAnimation(5);
                    },
                  ),
                ]),
                Consumer<AnimateViewProvider>(
                  builder: (context, animateViewProvider, _) => Expanded(
                    child: AnimateShiftView(
                      gridKey: animateViewProvider.gridKey,
                      length: animateViewProvider.length,
                      itemBuilder: (index) => _itemBuilder(true, index),
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 20,
                      crossAxisCount: 1,
                    ),
                  ),
                ),
              ])),
    );
  }

  Widget _animatedViewInGrid() {
    return ChangeNotifierProvider<AnimateViewProvider>(
      create: (context) => AnimateViewProvider()..setLength(_gridItems.length),
      child: Consumer<AnimateViewProvider>(
          builder: (context, provide, child) => Column(children: [
                Row(children: [
                  OutlinedButton(
                    child: const Text('update item count'),
                    onPressed: () {
                      provide.setLength(5);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('insert'),
                    onPressed: () {
                      _gridItems.insert(0, 9);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                      child: const Text('remove'),
                      onPressed: () async {
                        Widget removedItem = _itemBuilder(false, 2);
                        _gridItems.removeAt(0);
                        provide.removeAnimation(0, removedItem, isSizeAnimation: false);
                        await provide.waitForAnimationDone();
                        debugPrint('animation done');
                      }),
                  OutlinedButton(
                    child: const Text('reorder'),
                    onPressed: () async {
                      Widget removedItem = _itemBuilder(false, 2);
                      _gridItems.removeAt(2);
                      provide.removeAnimation(2, removedItem, isSizeAnimation: false);
                      await provide.waitForAnimationDone();
                      _gridItems.insert(0, 2);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                    child: const Text('next page'),
                    onPressed: () {
                      _gridItems = [11, 12, 13];
                      provide.nextPageAnimation(3);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('prev page'),
                    onPressed: () {
                      _gridItems = [21, 22, 23, 24, 25];
                      provide.prevPageAnimation(5);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('refresh'),
                    onPressed: () {
                      _gridItems = [31, 32, 33, 34, 35];
                      provide.refreshPageAnimation(5);
                    },
                  ),
                ]),
                Consumer<AnimateViewProvider>(
                  builder: (context, animateViewProvider, _) => Expanded(
                      child: AnimateView(
                    gridKey: animateViewProvider.gridKey,
                    length: animateViewProvider.length,
                    itemBuilder: (index) => _itemBuilder(false, index),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 20,
                    crossAxisCount: 3,
                  )),
                ),
              ])),
    );
  }

  Widget _animatedViewInListView(BuildContext context) {
    return ChangeNotifierProvider<AnimateViewProvider>(
      create: (context) => AnimateViewProvider()..setLength(_gridItems.length),
      child: Consumer<AnimateViewProvider>(
          builder: (context, provide, child) => Column(children: [
                OutlinedButton(
                  child: const Text('insert'),
                  onPressed: () {
                    _gridItems.insert(0, 9);
                    provide.insertAnimation();
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            height: 50,
                            color: Colors.amber,
                            child: const Center(child: Text('header')),
                          );
                        }
                        if (index == 2) {
                          return Container(
                            height: 50,
                            color: Colors.green,
                            child: const Center(child: Text('footer')),
                          );
                        }
                        return Consumer<AnimateViewProvider>(
                          builder: (context, animateViewProvider, _) => AnimateView(
                            gridKey: animateViewProvider.gridKey,
                            length: animateViewProvider.length,
                            controller: _scrollController,
                            itemBuilder: (index) => _itemBuilder(true, index),
                            shrinkWrap: true,
                          ),
                        );
                      }),
                ),
              ])),
    );
  }

  Widget _checkList(BuildContext context) {
    return CheckList(
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
              physics: const NeverScrollableScrollPhysics(),
              items: [
                ListItem(1, title: 'item 1'),
                ListItem(2, title: 'item 2', icon: Icons.card_giftcard),
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
                        height: 80,
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

  Widget _sidePanel(BuildContext context) {
    return SizedBox(
        height: 600,
        child: ChangeNotifierProvider<SidePanelProvider>.value(
            value: _sidePanelProvider,
            child: Consumer<SidePanelProvider>(
                builder: (context, sidePanelProvider, _) => Column(
                      children: [
                        Expanded(
                          child: SidePanel(
                            //autoHide: true,
                            sideWidth: 240,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: const Alignment(1, 1), // 10% of the width, so there are ten blinds.
                                colors: [
                                  Colors.grey.shade50,
                                  Colors.grey.shade100,
                                ], // red to yellow
                                tileMode: TileMode.repeated, // repeats the gradient over the canvas
                              ),
                            ),
                            sideWidget: const SizedBox(
                              height: double.infinity,
                              child: Text(
                                'side widget',
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            mainWidget: Scaffold(
                              appBar: AppBar(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                elevation: 1,
                                centerTitle: false,
                                titleSpacing: 0,
                                title: Row(children: [
                                  sidePanelProvider.leading,
                                  const Text('App Name'),
                                ]),
                                leading: const Icon(Icons.arrow_back_ios_new),
                              ),
                              body: Container(
                                color: Colors.white,
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                        child: const Text('test'),
                                        onPressed: () {
                                          //print('hello');
                                        }),
                                    const Text('hello'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))));
  }

  Widget _expansionDrawer(BuildContext context) {
    return ExpansionDrawer(
      initiallyExpanded: true,
      expandedHeight: 200,
      iconBackgroundColor: Colors.blue,
      iconColor: Colors.red,
      child: Container(height: 200, color: Colors.green),
    );
  }

  Widget _chatBubble(BuildContext context) {
    return Column(children: [
      const ChatBubble(
        isSender: false,
        color: Colors.blue,
        child: Text('Hello'),
      ),
      const ChatBubble(
        color: Colors.grey,
        child: Text('Hello World'),
      ),
      const ChatBubble(
        isSender: false,
        padding: EdgeInsets.zero,
        child: WebImage(
          url:
              'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        ),
      ),
      ChatBubble(
        isSender: false,
        color: Colors.blue,
        padding: EdgeInsets.zero,
        child: Container(
          height: 100,
          width: 980,
          color: Colors.red,
        ),
      ),
    ]);
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

  Widget _qrImage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: Colors.lightBlue,
      child: const SizedBox(
          width: 200,
          height: 200,
          child: QrImage(
            'http://cacake.piyuo.com/location=12348234234s',
          )),
    );
  }

  Widget _webImage(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => testing.RedrawProvider(),
        child: Consumer<testing.RedrawProvider>(
            builder: (context, redrawProvider, _) => Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          redrawProvider.redraw();
                        },
                        child: const Text('Redraw')),
                    Image.network(
                      'https://images.pexels.com/photos/7479003/pexels-photo-7479003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                      width: 300,
                      height: 300,
                    ),
                    WebImage(
                      url:
                          'https://images.pexels.com/photos/7479003/pexels-photo-7479003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                      width: 300,
                      height: 300,
                      border: Border.all(color: Colors.red, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    const WebImage(
                      url:
                          'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                      width: 300,
                      height: 300,
                      fadeIn: true,
                    ),
                    const WebImage(
                      url: 'https://not-exists',
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      width: 300,
                      height: 300,
                    ),
                    const WebImage(
                      url: '',
                      width: 300,
                      height: 300,
                    ),
                    const SizedBox(
                        height: 100,
                        width: 200,
                        child: WebImage(
                          url:
                              'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                        )),
                    const SizedBox(
                        height: 100,
                        width: 200,
                        child: WebImage(
                          url: '',
                        )),
                    const WebImage(
                      url: 'https://not-exists',
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    const SizedBox(
                        height: 100,
                        width: 200,
                        child: WebImage(
                          url: '',
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                  ],
                )));
  }

  Widget _singleImage(BuildContext context) {
    return const WebImage(
      url:
          'https://images.pexels.com/photos/7479003/pexels-photo-7479003.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    );
  }

  Widget _webVideo(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        WebVideo(
          url: 'https://download.samplelib.com/mp4/sample-5s.mp4',
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          width: 300,
          height: 200,
          onVideoLoaded: (video) => debugPrint('video loaded width:${video.size.width} height:${video.size.height}'),
        ),
        const WebVideo(
          url: 'https://download.samplelib.com/mp4/sample-5s.mp4',
          width: 360,
          height: 180,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        const WebVideo(
          url: 'https://download.samplelib.com/mp4/sample-5s.mp4',
          width: 360,
          height: 180,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          showControls: false,
        ),
        const WebVideo(
          url: 'https://notexistsanymore.com/sample-5s.mp4',
          width: 360,
          height: 180,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          showControls: false,
        ),
      ],
    );
  }

  Widget _isTouchSupported(BuildContext context) {
    return context.isTouchSupported ? const Text('touch supported') : const Text('touch not support');
  }

  Widget _noData(BuildContext context) {
    return const Column(
      children: [
        NoDataDisplay(),
        Divider(),
        LoadingDisplay(),
      ],
    );
  }

  Widget _shimmer(BuildContext context) {
    return const ShimmerScope(
        child: Wrap(spacing: 10, runSpacing: 10, children: [
      SizedBox(width: 200, height: 100, child: Shimmer()),
      Shimmer(width: 120, height: 30, radius: 15),
      FittedBox(
        child: Icon(
          Icons.image,
          size: 120,
        ),
      ),
      SizedBox(height: 180, width: 350, child: ShimmerRow()),
      SizedBox(height: 350, width: 220, child: ShimmerColumn()),
    ]));
  }

  Widget _animatedBadge(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Badge(
            label: Text('2'),
            child: Icon(Icons.shopping_bag, size: 24),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedBadge(
            label: '1',
            child: Icon(Icons.shopping_bag, size: 24),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedBadge(
            label: '8',
            onBottom: true,
            child: Icon(Icons.shopping_bag, size: 24),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedBadge(
            label: '2',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedBadge(
            label: '12',
            child: Text('Badge', style: TextStyle(fontSize: 20)),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: AnimatedBadge(
            label: '112',
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
    return const Column(
      children: [
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
    var searchBox3Controller = TextEditingController();
    var controller1 = TextEditingController();
    var focusNode1 = FocusNode();
    var focusSearch1 = FocusNode();
    var focusSearch2 = FocusNode();
    var focusSearch3 = FocusNode();
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const TextField(),
            SearchBox(
              focusNode: focusSearch1,
              controller: _searchBoxController,
              //prefixIcon: IconButton(icon: const Icon(Icons.menu), onPressed: () => debugPrint('menu pressed')),
            ),
            SearchBox(
              focusNode: focusSearch2,
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
            ),
            SearchBox(
              focusNode: focusSearch3,
              controller: searchBox3Controller,
              hintText: 'recent searches',
              recentKey: 'recentSearch',
              onSubmitted: (text) => debugPrint('submitted $text'),
            ),
            ElevatedButton(
                child: const Text('set text'),
                onPressed: () {
                  controller1.text = 'hello world';
                }),
            ElevatedButton(
                child: const Text('show suggestion'),
                onPressed: () {
                  focusNode1.requestFocus();
                }),
            ElevatedButton(
                child: const Text('hide suggestion'),
                onPressed: () {
                  focusNode1.unfocus();
                }),
            SearchingBar(
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
            SearchingBar(
              controller: TextEditingController(),
              onTextChanged: (text) => debugPrint('2.text changed: $text'),
            ),
            const Text('text not empty suggestion'),
            SearchingBar(
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
            SearchingBar(
              controller: TextEditingController(text: 'search now'),
              isDense: false,
            ),
          ],
        ));
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

  Widget _errorLabel(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: const Column(children: [
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

  Widget _statusLight(BuildContext context) {
    return const Row(children: [
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

  Widget _verticalOnPhoneLayout(BuildContext context) {
    return VerticalOnPhoneLayout(
        builder: (isColumn) => [
              Expanded(
                  child: Container(
                color: Colors.red,
                child: Text('$isColumn'),
              )),
              Expanded(
                  child: Container(
                color: Colors.blue,
                child: Text('$isColumn'),
              )),
            ]);
  }

  Widget _paddingToCenter(BuildContext context) {
    return Container(
      margin: paddingToCenter(context, 1024),
      color: Colors.red,
      height: 200,
    );
  }

  Widget _wrappedListView(BuildContext context) {
    return WrappedListView(
      children: [
        Wrapped(
          title: Container(
            width: double.infinity,
            height: 80,
            color: Colors.red,
          ),
          children: [
            Container(
              color: Colors.blue,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.orange,
            ),
          ],
        ),
        Wrapped(
          title: Container(
            width: double.infinity,
            height: 80,
            color: Colors.yellow,
          ),
          children: [
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.yellow,
            ),
            Container(
              color: Colors.orange,
            ),
            Container(
              color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }

  Widget _responsive(BuildContext context) {
    return Responsive(
      phoneScreen: () => Container(color: Colors.red, child: const Text('phone')),
      notPhoneScreen: () => Container(color: Colors.blue, child: const Text('not phone')),
      bigScreen: () => Container(color: Colors.green, child: const Text('big screen')),
    );
  }

  Widget _barView(BuildContext context) {
    return ResponsiveBarView(
      barBuilder: () => responsiveBar(context,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              debugPrint('back');
            },
          ),
          //backgroundColor: Colors.blue.withOpacity(.5),
          title: const Text('Hello World'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ]),
      slivers: [SliverToBoxAdapter(child: Container(height: 1200, color: Colors.green))],
    );
  }

  Widget _preview(BuildContext context) {
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
