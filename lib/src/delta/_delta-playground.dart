import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/custom.dart' as custom;
import 'custom-icons.dart';
import 'extensions.dart';
import 'web-image.dart';
import 'search-bar.dart';
import 'listing.dart';
import 'check.dart';
import 'hypertext.dart';
import 'async-provider.dart';
import 'await.dart';
import 'popup.dart';
import 'menu.dart';
import 'pull-refresh.dart';

var _pullRefreshCount = 8;

class DeltaPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();
  final GlobalKey btnMenuOnBottom = GlobalKey();

  final _listingController = ValueNotifier<int>(1);

  final _checkBoxController = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            SizedBox(
              width: 800,
              height: 400,
              child: _pullRefreshVertical(context),
            ),
            custom.example(
              context,
              text: 'web-image',
              child: _webImage(context),
            ),
            custom.example(
              context,
              text: 'search-bar',
              child: _searchBar(context),
            ),
            custom.example(
              context,
              text: 'round-check-box',
              child: _roundCheckBox(context),
            ),
            custom.example(
              context,
              text: 'hypertext',
              child: _hypertext(context),
            ),
            custom.example(
              context,
              text: 'await wait',
              child: _awaitWait(context),
            ),
            custom.example(
              context,
              text: 'await error',
              child: _awaitError(context),
            ),
            custom.example(
              context,
              text: 'popup',
              child: _popup(context),
            ),
            custom.example(
              context,
              text: 'listing',
              child: _listing(context),
            ),
            custom.example(
              context,
              text: 'menu',
              child: _menu(context),
            ),
            custom.example(
              context,
              text: 'menu on bottom',
              child: _menuOnBottom(context),
            ),
            custom.example(
              context,
              text: 'pull refresh',
              child: _pullRefresh(context),
            ),
            custom.example(
              context,
              text: 'pull refresh vertical',
              child: _pullRefreshVertical(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _webImage(BuildContext context) {
    return Container(
        color: context.themeColor(
          light: Colors.white,
          dark: Colors.black87,
        ),
        height: double.infinity,
        child: Row(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: WebImage(
                'https://www.apple.com/v/iphone-12/g/images/overview/design/design_compare_skinny__fhvbipafz2my_large.jpg',
              ),
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

  Widget _searchBar(BuildContext context) {
    var controller1 = TextEditingController();
    var focusNode1 = FocusNode();
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
                child: Text('set text'),
                onPressed: () {
                  controller1.text = 'hello world';
                }),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
                child: Text('show suggestion'),
                onPressed: () {
                  focusNode1.requestFocus();
                }),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
                child: Text('hide suggestion'),
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
            onSuggestionChanged: (text) => print('1. $text selected'),
            onTextChanged: (text) => print('1. text changed: $text'),
          ),
          SizedBox(height: 20),
          Text('no suggestion'),
          SearchBar(
            controller: TextEditingController(),
            onTextChanged: (text) => print('2.text changed: $text'),
          ),
          Text('text not empty suggestion'),
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
            onTextChanged: (text) => print('3.text changed: $text'),
          ),
          Text('not dense'),
          SearchBar(
            controller: TextEditingController(text: 'search now'),
            isDense: false,
          ),
        ]));
  }

  Widget _roundCheckBox(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Check(
              label: 'Remember me',
              controller: _checkBoxController,
            ),
            SizedBox(width: 20),
            Check(
              controller: _checkBoxController,
            ),
            SizedBox(width: 20),
            Check(
              checkColor: Colors.red,
              fillColor: Colors.green,
              controller: _checkBoxController,
            ),
            SizedBox(width: 20),
            Check(
              disabled: true,
              label: 'disabled',
              checkColor: Colors.red,
              fillColor: Colors.green,
              controller: _checkBoxController,
            ),
          ],
        ));
  }

  Widget _hypertext(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Hypertext(fontSize: 13)
        ..span('click to print to console')
        ..action('privacy', onTap: (_, __) => print('hello world'))
        ..span('click to open url')
        ..link('starbucks', url: 'https://www.starbucks.com'),
    );
  }

  Widget _awaitError(BuildContext context) {
    return TextButton(
      child: Text('provider with problem'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return WrongPage();
        }));
      },
    );
  }

  Widget _awaitWait(BuildContext context) {
    return TextButton(
      child: Text('provider need wait 30\'s'),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return WaitPage();
        }));
      },
    );
  }

  Widget _listing(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 300,
            height: 300,
            child: Listing<int>(
              controller: _listingController,
              shape: Shape.roundRight,
              selectedTileColor: Colors.green[400],
              selectedFontColor: Colors.grey[100],
              fontColor: Colors.green[600],
              items: [
                ListingItem(1, title: 'item 1'),
                ListingItem(2, title: 'item 2', icon: CustomIcons.cardGiftcard),
                ListingItem(3, title: 'item 3', icon: CustomIcons.cardGiftcard),
                ListingItem(4, title: 'item 4', icon: CustomIcons.cardGiftcard),
                ListingItem(5, title: 'item 5', icon: CustomIcons.cardGiftcard),
                ListingItem(6, title: 'item 6', icon: CustomIcons.cardGiftcard),
                ListingItem(7, title: 'item 7'),
                ListingItem(8, title: 'item 8'),
                ListingItem(9, title: 'item 9'),
                ListingItem(0, title: 'item 0'),
              ],
              tileBuilder: (BuildContext context, int key, String text, bool selected) {
                return key == 1
                    ? Container(
                        height: 100,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            text,
                            style: TextStyle(color: Colors.red),
                          ),
                        ))
                    : null;
              },
              onItemTap: (context, int key) {
                print('$key pressed');
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
                ListingItem(1, title: 'item 1'),
                ListingItem(2, title: 'item 2'),
                ListingItem(3, title: 'item 3'),
                ListingItem(4, title: 'item 4'),
                ListingItem(5, title: 'item 5'),
                ListingItem(6, title: 'item 6'),
              ],
              itemBuilder: (BuildContext context, int key, String text, bool selected) {
                return key == 5
                    ? Text(
                        text,
                        style: TextStyle(color: Colors.red),
                      )
                    : null;
              },
              onItemTap: (context, int key) {
                print('$key pressed');
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
      child: Text('popup'),
      onPressed: () {
        var rect = getWidgetGlobalRect(btnPopup);
        popup(context,
            rect: Rect.fromLTWH(rect.left, rect.bottom, rect.width, 200),
            child: Container(
              color: Colors.green,
              child: Center(
                  child: InkWell(
                onTap: () => print('hello'),
                child: Text(
                  'hello',
                  style: TextStyle(fontSize: 22),
                ),
              )),
            ));
      },
    );
  }

  Widget _menu(BuildContext context) {
    return Container(
        width: 240,
        child: ElevatedButton(
          key: btnMenu,
          child: Text('menu'),
          onPressed: () async {
            int? i = await menu<int>(
              context,
              target: btnMenu,
              items: [
                ListingItem(1, title: 'item 1'),
                ListingItem(2, title: 'item 2'),
                ListingItem(3, title: 'item 3'),
              ],
            );
            print(i != null ? 'select item $i' : 'not select');
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
          child: Text('menu on bottom'),
          onPressed: () async {
            int? i = await menu<int>(
              context,
              target: btnMenuOnBottom,
              items: [
                ListingItem(1, title: 'item 1'),
                ListingItem(2, title: 'item 2'),
                ListingItem(3, title: 'item 3'),
              ],
            );
            print(i != null ? 'select item $i' : 'not select');
          },
        ));
  }

  Widget _pullRefresh(BuildContext context) {
    return PullRefresh(
        scrollDirection: Axis.horizontal,
        onPullRefresh: (BuildContext context) async {
          await Future.delayed(Duration(seconds: 1));
          _pullRefreshCount--;
          return true;
        },
        onLoadMore: (BuildContext context) async {
          await Future.delayed(Duration(seconds: 1));
          _pullRefreshCount++;
          return true;
        },
        itemCount: (BuildContext context) {
          return _pullRefreshCount;
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            //height: double.infinity,
            color: Colors.blue[100],
            padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
            child: Text('item $index'),
          );
        });
  }

  Widget _pullRefreshVertical(BuildContext context) {
    return PullRefresh(onPullRefresh: (BuildContext context) async {
      return true;
    }, onLoadMore: (BuildContext context) async {
      return true;
    }, itemCount: (BuildContext context) {
      return _pullRefreshCount;
    }, itemBuilder: (BuildContext context, int index) {
      return Container(
        //height: double.infinity,
        color: Colors.blue[100],
        padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
        child: Text('item $index'),
      );
    });
  }
}

class WaitProvider extends AsyncProvider {
  @override
  Future<void> load(BuildContext context) async {
    await Future.delayed(Duration(seconds: 30));
  }
}

class WaitPage extends StatelessWidget {
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
