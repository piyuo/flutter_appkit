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

class DeltaPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  final _listingController = ValueNotifier<int>(1);

  final _checkBoxController = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            SizedBox(
              width: double.infinity,
//              height: 400,
              child: _awaitError(context),
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
              text: 'listing',
              child: _listing(context),
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
                ListingItem(key: 1, title: 'item 1'),
                ListingItem(key: 2, title: 'item 2', icon: CustomIcons.cardGiftcard),
                ListingItem(key: 3, title: 'item 3', icon: CustomIcons.cardGiftcard),
                ListingItem(key: 4, title: 'item 4', icon: CustomIcons.cardGiftcard),
                ListingItem(key: 5, title: 'item 5', icon: CustomIcons.cardGiftcard),
                ListingItem(key: 6, title: 'item 6', icon: CustomIcons.cardGiftcard),
                ListingItem(key: 7, title: 'item 7'),
                ListingItem(key: 8, title: 'item 8'),
                ListingItem(key: 9, title: 'item 9'),
                ListingItem(key: 0, title: 'item 0'),
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
                ListingItem(key: 1, title: 'item 1'),
                ListingItem(key: 2, title: 'item 2'),
                ListingItem(key: 3, title: 'item 3'),
                ListingItem(key: 4, title: 'item 4'),
                ListingItem(key: 5, title: 'item 5'),
                ListingItem(key: 6, title: 'item 6'),
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
