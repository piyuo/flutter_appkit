import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/dialog/dialog.dart' as dialog;

import '../delta.dart';

final _listingController = ValueNotifier<int>(1);

final _checkListController = ValueNotifier<List<int>>([]);

final sidePanelProvider = SidePanelProvider();

var scrollController = ScrollController();

final GlobalKey<AnimateGridState> gridKey = GlobalKey<AnimateGridState>();

var gridItems = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

int gridIndex = 10;

Widget itemBuilder(bool isListView, int index) {
  int item = gridItems[index];
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
    onSearch: (text) => debugPrint('search:$text'),
    onSearchBegin: () => debugPrint('search begin'),
    onSearchEnd: () => debugPrint('search end'),
  );

  base.start(
    appName: 'delta example',
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

final _scrollController = ScrollController();

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
    final width = MediaQuery.of(context).size.width;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigationViewProvider<int>>(
              create: (context) => NavigationViewProvider<int>(value: 0)),
          ChangeNotifierProvider.value(value: _checkController),
        ],
        child: Consumer2<ValueNotifier<bool>, NavigationViewProvider<int>>(
            builder: (context, model, navigationViewProvider, child) => Scaffold(
                  appBar: AppBar(
                    leading: isPhoneScreen(width) && !navigationViewProvider.isSideView
                        ? IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () => navigationViewProvider.useSideView(),
                          )
                        : null,
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: _groupListView(context),
                        ),
                        SizedBox(
                          height: 300,
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: [
                                testing.ExampleButton(
                                    label: 'navigation scaffold',
                                    useScaffold: false,
                                    builder: () => _navigationScaffold(context)),
                                testing.ExampleButton(
                                    label: 'navigation view',
                                    useScaffold: false,
                                    builder: () => _navigationView(context)),
                                testing.ExampleButton(label: 'mounted pop', builder: () => _mounted(context)),
                                testing.ExampleButton(label: 'search trigger', builder: () => _searchTrigger(context)),
                                testing.ExampleButton(label: 'refresh more', builder: () => _refreshMoreView(context)),
                                testing.ExampleButton(label: 'group list view', builder: () => _groupListView(context)),
                                testing.ExampleButton(label: 'button panel', builder: () => _buttonPanel(context)),
                                testing.ExampleButton(
                                    label: 'is touch enabled?', builder: () => _isTouchSupported(context)),
                                testing.ExampleButton(label: 'no data', builder: () => _noData(context)),
                                testing.ExampleButton(label: 'shimmer', builder: () => _shimmer(context)),
                                testing.ExampleButton(label: 'countdown', builder: () => _notificationBadge(context)),
                                testing.ExampleButton(label: 'countdown', builder: () => _countdown(context)),
                                testing.ExampleButton(label: 'search box', builder: () => _searchBox(context)),
                                testing.ExampleButton(label: 'refresh button', builder: () => _refreshButton(context)),
                                testing.ExampleButton(label: 'indicator', builder: () => _indicator(context)),
                                testing.ExampleButton(label: 'tap breaker', builder: () => _tapBreaker(context)),
                                testing.ExampleButton(label: 'web image', builder: () => _webImage(context)),
                                testing.ExampleButton(label: 'checkbox', builder: () => _checkbox(context, model)),
                                testing.ExampleButton(label: 'menu button', builder: () => _menuButton(context)),
                                testing.ExampleButton(label: 'status light', builder: () => _statusLight(context)),
                                testing.ExampleButton(label: 'switch', builder: () => _switching(context)),
                                testing.ExampleButton(label: 'segment', builder: () => _segment(context)),
                                testing.ExampleButton(label: 'error label', builder: () => _errorLabel(context)),
                                testing.ExampleButton(label: 'side panel', builder: () => _sidePanel(context)),
                                testing.ExampleButton(label: 'listing', builder: () => _listing(context)),
                                testing.ExampleButton(label: 'check list', builder: () => _checkList(context)),
                                testing.ExampleButton(
                                    label: 'show responsive dialog', builder: () => _showResponsiveDialog(context)),
                                testing.ExampleButton(label: 'fold panel', builder: () => _foldPanel(context)),
                                testing.ExampleButton(label: 'toolbar', builder: () => _toolbar(context)),
                                testing.ExampleButton(
                                    label: 'padding to center', builder: () => _paddingToCenter(context)),
                                testing.ExampleButton(
                                    label: 'layout dynamic bottom side',
                                    builder: () => _layoutDynamicBottomSide(context)),
                                testing.ExampleButton(
                                    label: 'wrapped-list-view', builder: () => _wrappedListView(context)),
                                testing.ExampleButton(label: 'responsive', builder: () => _responsive(context)),
                                testing.ExampleButton(
                                  label: 'shifter',
                                  builder: () => _shifter(),
                                ),
                                testing.ExampleButton(
                                  label: 'animated grid',
                                  builder: () => _animatedGrid(),
                                ),
                                testing.ExampleButton(
                                  label: 'animated view in list',
                                  builder: () => _animatedViewInList(),
                                ),
                                testing.ExampleButton(
                                  label: 'animated view in grid',
                                  builder: () => _animatedViewInGrid(),
                                ),
                                testing.ExampleButton(
                                  label: 'animated view in list view',
                                  builder: () => _animatedViewInListView(),
                                ),
                                testing.ExampleButton(
                                  label: 'axis animate',
                                  builder: () => _axisAnimate(),
                                ),
                                testing.ExampleButton(
                                  label: 'transform container',
                                  builder: () => _transformContainer(),
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

  Widget _shifter() {
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
    int item = gridItems[index];
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

  Widget _animatedGrid() {
    return Column(children: [
      Row(children: [
        OutlinedButton(
          child: const Text('insert'),
          onPressed: () {
            gridItems.insert(0, gridIndex++);
            gridKey.currentState!.insertItem(0);
          },
        ),
        OutlinedButton(
            child: const Text('remove'),
            onPressed: () {
              gridKey.currentState!.removeItem(1, (_, animation) => slideIt(context, 0, animation));
              gridItems.removeAt(1);
            }),
      ]),
      Expanded(
          child: AnimateGrid(
        key: gridKey,
        mainAxisSpacing: 5,
        crossAxisSpacing: 20,
        crossAxisCount: 2,
        initialItemCount: gridItems.length,
        itemBuilder: (context, index, animation) {
          return slideIt(context, index, animation); // Refer step 3
        },
      )),
    ]);
  }

  Widget _axisAnimate() {
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

  Widget _transformContainer() {
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

  Widget _animatedViewInList() {
    return ChangeNotifierProvider<AnimateViewProvider>(
      create: (context) => AnimateViewProvider()..setLength(gridItems.length),
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
                      gridItems.insert(0, 9);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                      child: const Text('remove'),
                      onPressed: () async {
                        Widget removedItem = itemBuilder(true, 2);
                        gridItems.removeAt(2);
                        provide.removeAnimation(2, removedItem, true);
                        await provide.waitForAnimationDone();
                        debugPrint('animation done');
                      }),
                  OutlinedButton(
                    child: const Text('reorder'),
                    onPressed: () {
                      Widget removedItem = itemBuilder(true, 2);
                      gridItems.removeAt(2);
                      provide.removeAnimation(2, removedItem, true);
                      gridItems.insert(0, 2);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                    child: const Text('next page'),
                    onPressed: () {
                      gridItems = [11, 12, 13];

                      provide.nextPageAnimation(3);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('prev page'),
                    onPressed: () {
                      gridItems = [21, 22, 23, 24, 25];
                      provide.prevPageAnimation(5);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('refresh'),
                    onPressed: () {
                      gridItems = [31, 32, 33, 34, 35];
                      provide.refreshPageAnimation(5);
                    },
                  ),
                ]),
                Consumer<AnimateViewProvider>(
                  builder: (context, provide, _) => Expanded(
                      child: AnimateView(
                    animateViewProvider: provide,
                    itemBuilder: (index) => itemBuilder(true, index),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 20,
                    crossAxisCount: 1,
                  )),
                ),
              ])),
    );
  }

  Widget _animatedViewInGrid() {
    return ChangeNotifierProvider<AnimateViewProvider>(
      create: (context) => AnimateViewProvider()..setLength(gridItems.length),
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
                      gridItems.insert(0, 9);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                      child: const Text('remove'),
                      onPressed: () async {
                        Widget removedItem = itemBuilder(false, 2);
                        gridItems.removeAt(0);
                        provide.removeAnimation(0, removedItem, false);
                        await provide.waitForAnimationDone();
                        debugPrint('animation done');
                      }),
                  OutlinedButton(
                    child: const Text('reorder'),
                    onPressed: () async {
                      Widget removedItem = itemBuilder(false, 2);
                      gridItems.removeAt(2);
                      provide.removeAnimation(2, removedItem, false);
                      await provide.waitForAnimationDone();
                      gridItems.insert(0, 2);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                    child: const Text('next page'),
                    onPressed: () {
                      gridItems = [11, 12, 13];
                      provide.nextPageAnimation(3);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('prev page'),
                    onPressed: () {
                      gridItems = [21, 22, 23, 24, 25];
                      provide.prevPageAnimation(5);
                    },
                  ),
                  OutlinedButton(
                    child: const Text('refresh'),
                    onPressed: () {
                      gridItems = [31, 32, 33, 34, 35];
                      provide.refreshPageAnimation(5);
                    },
                  ),
                ]),
                Consumer<AnimateViewProvider>(
                  builder: (context, provide, _) => Expanded(
                      child: AnimateView(
                    animateViewProvider: provide,
                    itemBuilder: (index) => itemBuilder(false, index),
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 20,
                    crossAxisCount: 3,
                  )),
                ),
              ])),
    );
  }

  Widget _animatedViewInListView() {
    return ChangeNotifierProvider<AnimateViewProvider>(
      create: (context) => AnimateViewProvider()..setLength(gridItems.length),
      child: Consumer<AnimateViewProvider>(
          builder: (context, provide, child) => Column(children: [
                OutlinedButton(
                  child: const Text('insert'),
                  onPressed: () {
                    gridItems.insert(0, 9);
                    provide.insertAnimation();
                  },
                ),
                Expanded(
                    child: ListView.builder(
                        controller: scrollController,
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
                            builder: (context, provide, _) => AnimateView(
                              animateViewProvider: provide,
                              controller: scrollController,
                              itemBuilder: (index) => itemBuilder(true, index),
                              shrinkWrap: true,
                            ),
                          );
                        })),
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
            value: sidePanelProvider,
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

  Widget _webImage(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: [
        OutlinedButton(
          child: const Text('clear image cache'),
          onPressed: () => webImageClearCache(),
        ),
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
          opacity: const AlwaysStoppedAnimation<double>(0.5),
          border: Border.all(color: Colors.red, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        const WebImage(
          url:
              'https://images.pexels.com/photos/11213783/pexels-photo-11213783.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
          width: 300,
          height: 300,
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
    );
  }

  Widget _isTouchSupported(BuildContext context) {
    return context.isTouchSupported ? const Text('touch supported') : const Text('touch not support');
  }

  Widget _navigationScaffold(BuildContext context) {
    return NavigationScaffold(
      leadingInRail: Container(width: 256, height: 100, color: Colors.blue),
      trailingInRail: Container(width: 256, height: 100, color: Colors.green),
      destinations: const [
        Navigation(title: 'Dashboard', icon: Icons.dashboard),
        Navigation(title: 'Message', icon: Icons.chat),
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

  Widget _navigationView(BuildContext context) {
    return NavigationView<int>(
      sideBuilder: (navigationViewProvider) => Container(
          color: Colors.blue,
          //constraints: const BoxConstraints.expand(),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => navigationViewProvider.show(context, 1),
                child: const Text('show 1'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => navigationViewProvider.show(context, 2),
                child: const Text('show 2'),
              ),
            ],
          )),
      builder: (int value) => Container(
        color: Colors.green,
        child: Column(children: [Text('$value')]),
      ),
    );
  }

  Widget _buttonPanel(BuildContext context) {
    return ButtonPanel<String>(
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
    );
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
        child: Wrap(spacing: 10, runSpacing: 10, children: const [
      SizedBox(width: 200, height: 100, child: Shimmer()),
      Shimmer(width: 120, height: 30, radius: 15),
      FittedBox(
        child: Icon(
          Icons.image,
          size: 120,
        ),
      ),
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
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            const TextField(),
            SearchBox(
              controller: _searchBoxController,
              //prefixIcon: IconButton(icon: const Icon(Icons.menu), onPressed: () => debugPrint('menu pressed')),
            ),
            SearchBox(
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
      const Text('Empty'),
      const MenuButton<String>(
        onPressed: null,
        selectedValue: '2',
        selection: {},
      ),
    ]);
  }

  Widget _groupListView(BuildContext context) {
    List items = [
      {'name': 'John', 'group': 'Team A'},
      {'name': 'Will', 'group': 'Team B'},
      {'name': 'Beth', 'group': 'Team A'},
      {'name': 'Miranda', 'group': 'Team B'},
      {'name': 'Mike', 'group': 'Team C'},
      {'name': 'Danny', 'group': 'Team C'},
    ];

    return GroupListView<dynamic, String>(
      items: items,
      groupBy: (item) => item['group'],
      separator: const SizedBox(),
      itemBuilder: (dynamic item) => ListTile(
        title: Text(
          item['name'],
        ),
      ),
      groupBuilder: (String groupByValue) => Container(
        margin: const EdgeInsets.fromLTRB(10, 1, 10, 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.orange,
        ),
        child: ListTile(
          title: Text(groupByValue),
        ),
      ),
    );
  }

  Widget _refreshMoreView(BuildContext context) {
    final List<String> items = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N'];
    //final List<String> items = <String>['A', 'B', 'C'];

    return RefreshView(
      scrollController: _scrollController,
      onRefresh: () async {
        debugPrint('refresh');
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('refresh done');
      },
      onLoadMore: () async {
        debugPrint('more');
        await Future.delayed(const Duration(seconds: 2));
        debugPrint('more done');
      },
      child: ListView.builder(
        controller: _scrollController,
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
      ),
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

  Widget _foldPanel(BuildContext context) {
    return FoldPanel(
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

  Widget _showResponsiveDialog(BuildContext context) {
    return OutlinedButton(
      child: const Text('show responsive dialog'),
      onPressed: () => showResponsiveDialog<void>(
        context,
        itemCount: 11,
        itemBuilder: (context, index) => const [
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          SizedBox(height: 20),
          SizedBox(height: 180, child: Placeholder()),
          Text('hello world'),
          SizedBox(height: 20),
        ][index],
      ),
    );
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

  Widget _layoutDynamicBottomSide(BuildContext context) {
    return DynamicBottomSide(
      leftBuilder: () => Container(
        color: Colors.red,
        width: 200,
      ),
      centerBuilder: () => Container(color: Colors.yellow),
      sideBuilder: () => Container(
        color: Colors.blue,
        width: 300,
      ),
      bottomBuilder: () => Container(
        color: Colors.green,
        height: 100,
      ),
    );
  }

  Widget _responsive(BuildContext context) {
    return Responsive(
      phoneScreen: () => Container(color: Colors.red, child: const Text('phone')),
      notPhoneScreen: () => Container(color: Colors.blue, child: const Text('not phone')),
      bigScreen: () => Container(color: Colors.green, child: const Text('big screen')),
    );
  }

  Widget _toolbar(BuildContext context) {
    return Column(children: [
      Toolbar(
//        color: Colors.blue.shade300,
        //      activeColor: Colors.blue,
        items: [
          ToolButton(
            label: 'Show tool sheet',
            icon: Icons.new_label,
            onPressed: () async {
              await showToolSheet(
                context,
                items: [
                  ToolButton(
                    label: 'New File',
                    icon: Icons.new_label,
                    onPressed: () => debugPrint('new_file pressed'),
                  ),
                  ToolButton(
                    label: 'Disabled',
                    icon: Icons.cabin,
                  ),
                  ToolButton(
                    label: 'abc',
                    icon: Icons.abc_outlined,
                    onPressed: () => debugPrint('abc pressed'),
                  ),
                  ToolSelection(
                    label: 'Rows per page',
                    icon: Icons.table_rows,
                    selection: {
                      '10': '10 rows2',
                      '20': '20 rows2',
                      '50': '50 rows2',
                      '100': '100 rows2',
                      '200': '200 rows2',
                    },
                    onPressed: (value) => debugPrint('$value pressed'),
                  ),
                  ToolButton(
                    label: 'hi',
                    icon: Icons.hail,
                    onPressed: () => debugPrint('hi pressed'),
                  ),
                  ToolButton(
                    label: 'hello',
                    icon: Icons.handshake,
                    onPressed: () => debugPrint('hello pressed'),
                  ),
                ],
              );
            },
            space: 10,
          ),
          ToolButton(
            label: 'List View',
            icon: Icons.list,
            onPressed: () => debugPrint('list_view pressed'),
            active: true,
          ),
          ToolButton(
            label: 'Grid View',
            icon: Icons.grid_view,
            onPressed: () => debugPrint('grid_view pressed'),
            active: false,
            space: 10,
          ),
          ToolSelection(
            width: 150,
            text: 'page 2 of more',
            label: 'rows per page',
            selection: {
              '10': '10 rows',
              '20': '20 rows',
              '50': '50 rows',
            },
            onPressed: (value) => debugPrint('$value pressed'),
          ),
          ToolSelection(
            width: 120,
            text: 'Disabled',
            label: 'disabled',
            selection: {
              '10': '10 rows',
            },
          ),
          ToolButton(
            label: 'disabled',
            icon: Icons.delete,
          ),
          ToolSpacer(),
          ToolButton(
            label: 'Back',
            icon: Icons.chevron_left,
            onPressed: () => debugPrint('back pressed'),
          ),
          ToolButton(
            label: 'Next',
            icon: Icons.chevron_right,
            onPressed: () => debugPrint('next pressed'),
          ),
          ToolButton(
            label: 'Disabled',
            icon: Icons.cabin,
            onPressed: () => debugPrint('disabled pressed'),
            space: 10,
          ),
        ],
      ),
    ]);
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
