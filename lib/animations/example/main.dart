// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import '../animations.dart';

var scrollController = ScrollController();

final GlobalKey<AnimatedGridState> gridKey = GlobalKey<AnimatedGridState>();

var gridItems = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

int gridIndex = 10;

Widget itemBuilder(bool isListView, int index) {
  if (isListView) {
    return SizedBox(
      // Actual widget to display
      height: 64.0,
      child: Card(
        child: Center(
          child: Text('Item $index'),
        ),
      ),
    );
  }
  return Card(
    child: Center(
      child: Text('Item $index'),
    ),
  );
}

main() => app.start(
      appName: 'animation',
      routes: {
        '/': (context, state, data) => const AnimationExample(),
      },
    );

class AnimationExample extends StatefulWidget {
  const AnimationExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimationExampleState();
}

class _AnimationExampleState extends State<AnimationExample> {
  int shifterIndex = 1;
  bool shifterReverse = false;
  bool shifterVertical = false;

  bool isSwitched = false;

  int counter = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _animatedView(),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  testing.ExampleButton(
                    label: 'shifter',
                    builder: () => _shifter(),
                  ),
                  testing.ExampleButton(
                    label: 'animated grid',
                    builder: () => _animatedGrid(),
                  ),
                  testing.ExampleButton(
                    label: 'animated view',
                    builder: () => _animatedView(),
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
                ])),
          ],
        ),
      ),
    );
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
                  key: ValueKey(shifterIndex), width: 200, height: 200, color: Colors.red, child: const Text('text 1'))
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
              gridKey.currentState!.removeItem(0, (_, animation) => slideIt(context, 0, animation));
              gridItems.removeAt(0);
            }),
      ]),
      Expanded(
          child: AnimatedGrid(
        key: gridKey,
        crossAxisCount: 1,
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

  Widget _animatedView() {
    return ChangeNotifierProvider<AnimatedViewProvider>(
      create: (context) => AnimatedViewProvider(gridItems.length),
      child: Consumer<AnimatedViewProvider>(
          builder: (context, provide, child) => Column(children: [
                Row(children: [
                  OutlinedButton(
                    child: const Text('update item count'),
                    onPressed: () {
                      provide.itemCount = 5;
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
                      onPressed: () {
                        int item = gridItems[2];
                        gridItems.removeAt(2);
                        provide.removeAnimation(2, true, itemBuilder(true, item));
                      }),
                  OutlinedButton(
                    child: const Text('reorder'),
                    onPressed: () {
                      int item = gridItems[2];
                      gridItems.removeAt(2);
                      provide.removeAnimation(2, true, itemBuilder(true, item));
                      gridItems.insert(0, 2);
                      provide.insertAnimation();
                    },
                  ),
                  OutlinedButton(
                    child: const Text('next page'),
                    onPressed: () {
                      gridItems = [11, 12, 13];
                      provide.nextPageAnimation();
                    },
                  ),
                  OutlinedButton(
                    child: const Text('prev page'),
                    onPressed: () {
                      gridItems = [21, 22, 23, 24, 25];
                      provide.prevPageAnimation();
                    },
                  ),
                ]),
                const Expanded(child: AnimatedView(itemBuilder: itemBuilder)),
              ])),
    );
  }

  Widget _animatedViewInListView() {
    return ChangeNotifierProvider<AnimatedViewProvider>(
      create: (context) => AnimatedViewProvider(gridItems.length),
      child: Consumer<AnimatedViewProvider>(
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
                          return AnimatedView(
                            controller: scrollController,
                            itemBuilder: itemBuilder,
                            shrinkWrap: true,
                          );
                        })),
              ])),
    );
  }
}
