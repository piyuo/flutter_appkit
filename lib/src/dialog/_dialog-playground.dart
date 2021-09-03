import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta.dart';
import 'alert.dart';
import 'toast.dart';
import 'slide.dart';
import 'route.dart';
import 'popup.dart';
import 'show-more.dart';
import 'hypertext.extension.dart';

class DialogPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnShowMore = GlobalKey();
  final GlobalKey btnShowMoreOffset = GlobalKey();
  final GlobalKey btnShowMoreText = GlobalKey();
  final GlobalKey btnPopup = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
                  colors: [const Color(0xffee0000), const Color(0xffeeee00)], // red to yellow
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    children: [
                      ElevatedButton(
                        child: Text('alert'),
                        onPressed: () => alert(
                          context,
                          'hi',
                        ),
                      ),
                      ElevatedButton(
                        child: Text('alert warning'),
                        onPressed: () => alert(context, 'hello world1', warning: true),
                      ),
                      ElevatedButton(
                        child: Text('alert title'),
                        onPressed: () => alert(context, 'hello world', title: 'title'),
                      ),
                      ElevatedButton(
                        child: Text('alert title/footer'),
                        onPressed: () => alert(context, 'hello world', title: 'title', footer: 'footer'),
                      ),
                      ElevatedButton(
                        child: Text('alert yes/no/cancel'),
                        onPressed: () async {
                          var result = await alert(
                            context,
                            'do you want delete this document?',
                            buttonYes: true,
                            buttonNo: true,
                            buttonCancel: true,
                          );
                          if (result == true) {
                            ok(context, 'yes');
                          } else if (result == false) {
                            ok(context, 'no');
                          } else if (result == null) {
                            ok(context, 'cancel');
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Text('alert ok/cancel'),
                        onPressed: () async {
                          var result = await alert(
                            context,
                            'save this document?',
                            buttonSave: true,
                            buttonCancel: true,
                          );
                          if (result == true) {
                            ok(context, 'ok');
                          } else if (result == null) {
                            ok(context, 'cancel');
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Text('alert warning email us'),
                        onPressed: () =>
                            alert(context, 'error message', footer: 'description', emailUs: true, warning: true),
                      ),
                      ElevatedButton(
                        child: Text('alert long content'),
                        onPressed: () => alert(
                          context,
                          'this is a very long content, it should cover 3 or 4 more line. we need test long message can read easily',
                          title: 'this is a very long title. it should cover 2 line',
                          footer:
                              'this is a very long footer, it should cover 3 or 4 more line. we need test long message can read easily',
                          emailUs: true,
                          scrollContent: true,
                          icon: CustomIcons.alarm,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('tooltip'),
                  SizedBox(height: 20),
                  Wrap(
                    children: [
                      ElevatedButton(
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
                      ),
                      ElevatedButton(
                        key: btnShowMore,
                        child: Text('show more'),
                        onPressed: () => targetShowMore(
                          context,
                          targetKey: btnShowMore,
                          size: Size(180, 180),
                          child: Container(
                              alignment: Alignment.center,
                              child: Text('hello world',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ))),
                        ),
                      ),
                      ElevatedButton(
                        key: btnShowMoreOffset,
                        child: Text('show more offset'),
                        onPressed: () {
                          var rect = getWidgetGlobalRect(btnShowMoreOffset);
                          showMore(
                            context,
                            size: Size(180, 120),
                            targetRect: rect,
                            child: Container(
                                alignment: Alignment.center,
                                child: Text('hello world',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none,
                                    ))),
                          );
                        },
                      ),
                      ElevatedButton(
                        key: btnShowMoreText,
                        child: Text('show more text'),
                        onPressed: () {
                          var rect = getWidgetGlobalRect(btnShowMoreText);
                          showMoreText(
                            context,
                            targetRect: rect,
                            size: Size(180, 120),
                            text: 'hello world',
                          );
                        },
                      ),
                      Hypertext(fontSize: 13)
                        ..moreText('more text', content: 'hello world')
                        ..moreDoc('more on doc', docName: 'privacy')
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('loading'),
                  SizedBox(height: 20),
                  Wrap(children: [
                    ElevatedButton(
                      child: Text('loading'),
                      onPressed: () async {
                        loading(context);
                        await Future.delayed(Duration(seconds: 3));
                        dismiss();
                      },
                    ),
                    ElevatedButton(
                      child: Text('loading text'),
                      onPressed: () async {
                        loading(context, text: 'loading');
                        await Future.delayed(Duration(seconds: 3));
                        dismiss();
                      },
                    ),
                    ElevatedButton(
                      child: Text('progress'),
                      onPressed: () async {
                        for (int i = 0; i <= 10; i++) {
                          await progress(context, i / 10);
                          await Future.delayed(Duration(milliseconds: 500));
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text('progress text'),
                      onPressed: () async {
                        for (int i = 0; i <= 10; i++) {
                          String text = 'preparing';
                          if (i > 5) {
                            text = 'creating';
                          }
                          await progress(context, i / 10, text: text);
                          await Future.delayed(Duration(milliseconds: 500));
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text('dismiss'),
                      onPressed: () => dismiss(),
                    ),
                    ElevatedButton(
                      child: Text('toast'),
                      onPressed: () => ok(context, 'add item to cart'),
                    ),
                    ElevatedButton(
                      child: Text('fail'),
                      onPressed: () => wrong(context, 'item already exist'),
                    ),
                    ElevatedButton(
                      child: Text('info'),
                      onPressed: () => info(context,
                          text: 'network is slow than usual',
                          widget: Icon(
                            CustomIcons.wifi,
                            size: 68,
                            color: Theme.of(context).accentColor,
                          )),
                    ),
                    ElevatedButton(
                      child: Text('slow network'),
                      onPressed: () async {
                        loading(context);
                        await Future.delayed(Duration(seconds: 3));
                        loading(context, text: 'network is slow');
                        await Future.delayed(Duration(seconds: 3));
                        dismiss();
                      },
                    ),
                  ]),
                  SizedBox(height: 20),
                  Text('slide'),
                  SizedBox(height: 20),
                  Wrap(children: [
                    ElevatedButton(
                      child: Text('slide'),
                      onPressed: () => slide(
                        context,
                        Container(height: 300, child: Text('hi')),
                      ),
                    ),
                  ]),
                  SizedBox(height: 20),
                  Text('route or dialog'),
                  SizedBox(height: 20),
                  Wrap(children: [
                    ElevatedButton(
                      child: Text('normal'),
                      onPressed: () => routeOrDialog(
                        context,
                        Container(color: Colors.blue),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('route'),
                      onPressed: () => routeOrDialog(
                        context,
                        Container(color: Colors.blue),
                        min: Size(300, 400),
                      ),
                    ),
                    ElevatedButton(
                      child: Text('dialog'),
                      onPressed: () => routeOrDialog(
                        context,
                        Container(color: Colors.blue),
                        min: Size(3000, 4000),
                      ),
                    ),
                  ]),
                ],
              ))),
    );
  }
}
