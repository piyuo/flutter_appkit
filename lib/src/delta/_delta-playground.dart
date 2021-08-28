import 'package:flutter/material.dart';
import 'package:libcli/custom.dart' as custom;
import 'extensions.dart';
import 'web-image.dart';
import 'search-bar.dart';

class DeltaPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Wrap(
          children: [
            SizedBox(
              width: double.infinity,
//              height: 400,
              child: _searchBar(context),
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
}
