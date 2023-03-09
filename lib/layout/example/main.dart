import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/testing/testing.dart' as testing;
import '../layout.dart';

final _listingController = ValueNotifier<int>(1);

final _checkListController = ValueNotifier<List<int>>([]);

final sidePanelProvider = SidePanelProvider();

main() {
  _listingController.addListener(
    () => debugPrint(_listingController.value.toString()),
  );

  app.start(
    title: 'layout example',
    routes: {
      '/': (context, state, data) => const LayoutExample(),
    },
  );
}

class LayoutExample extends StatelessWidget {
  const LayoutExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: _sliverScaffold(context)),
      Wrap(
        children: [
          testing.ExampleButton(label: 'sliver scaffold', builder: () => _sliverScaffold(context), useScaffold: false),
          testing.ExampleButton(label: 'side panel', builder: () => _sidePanel(context)),
          testing.ExampleButton(label: 'story line', builder: () => _storyLine(context)),
          testing.ExampleButton(label: 'listing', builder: () => _listing(context)),
          testing.ExampleButton(label: 'check list', builder: () => _checkList(context)),
        ],
      )
    ]);
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

  Widget _sliverScaffold(BuildContext context) {
    return SliverScaffold(
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      )),
      padding: const EdgeInsets.all(10),
      appBarPadding: const EdgeInsets.all(10),
      appBar: SliverAppBar(
        pinned: true,
        backgroundColor: Colors.blue.withOpacity(0.5),
      ),
      children: [
        Container(
          height: 200,
          color: Colors.red,
          child: const Text('hello1'),
        ),
        Container(
          height: 200,
          color: Colors.green,
          child: const Text('hello1'),
        ),
        Container(
          height: 200,
          color: Colors.yellow,
          child: const Text('hello3'),
        ),
        Container(
          height: 200,
          color: Colors.orange,
          child: const Text('hello4'),
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

  Widget _storyLine(BuildContext context) {
    return StoryLine(
        title: 'Notification',
        subtitle: 'open',
        stories: [
          SimpleStory(
            utcDate: DateTime.now().toUtc(),
            icon: Icons.takeout_dining,
            text: 'you have new takeout order',
            title: 'pork rice, beef noddle and more ...',
            color: Colors.red.shade700,
          ),
          SimpleStory(
            utcDate: DateTime.now().toUtc(),
            icon: Icons.bookmark,
            text: 'Someone asking question about',
            title: 'Pork Rice',
            color: Colors.blue.shade700,
          ),
          SimpleStory(
            utcDate: DateTime.now().toUtc(),
            icon: Icons.card_giftcard,
            text: 'Order delivered',
            title: 'pork rice, beef noodle and more',
            color: Colors.green.shade700,
          ),
          //Story(utcDate: DateTime.now().add(Duration(hours: -1)).toUtc(), key: 'order2'),
          //Story(utcDate: DateTime.now().add(Duration(hours: -1)).toUtc(), key: 'order3'),
          //Story(utcDate: DateTime.now().add(Duration(hours: -1)).toUtc(), key: 'order4'),
          //Story(utcDate: DateTime.now().add(Duration(days: -1)).toUtc(), key: 'order5'),
        ],
        builder: SimpleStory.builder);
  }
}
