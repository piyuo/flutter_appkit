import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/app/app.dart' as app;
import '../gallery.dart';

main() {
  _listingController.addListener(
    () => debugPrint(_listingController.value.toString()),
  );

  app.start(
    appName: 'gallery',
    routes: {
      '/': (context, state, data) => const GalleryExample(),
    },
  );
}

final _listingController = ValueNotifier<int>(1);

final _checkListController = ValueNotifier<List<int>>([]);

class GalleryExample extends StatelessWidget {
  const GalleryExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _listing(context),
            ),
            Wrap(
              children: [
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
              ],
            ),
          ],
        ),
      ),
    );
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
}
