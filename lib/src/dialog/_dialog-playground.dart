import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta.dart';
import 'alert.dart';
import 'toast.dart';
import 'slide.dart';
import 'route.dart';
import 'show-more.dart';
import 'banner.dart';
import 'hypertext.extension.dart';

class DialogPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnShowMore = GlobalKey();
  final GlobalKey btnShowMoreOffset = GlobalKey();
  final GlobalKey btnShowMoreText = GlobalKey();

  DialogPlayground({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
                  colors: [Color(0xffee0000), Color(0xffeeee00)], // red to yellow
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    children: [
                      ElevatedButton(
                        child: const Text('alert'),
                        onPressed: () => alert(
                          context,
                          'hi',
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('alert warning'),
                        onPressed: () => alert(context, 'hello world1', warning: true),
                      ),
                      ElevatedButton(
                        child: const Text('alert title'),
                        onPressed: () => alert(context, 'hello world', title: 'title'),
                      ),
                      ElevatedButton(
                        child: const Text('alert title/footer'),
                        onPressed: () => alert(context, 'hello world', title: 'title', footer: 'footer'),
                      ),
                      ElevatedButton(
                        child: const Text('alert yes/no/cancel'),
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
                        child: const Text('alert ok/cancel'),
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
                        child: const Text('alert warning email us'),
                        onPressed: () =>
                            alert(context, 'error message', footer: 'description', emailUs: true, warning: true),
                      ),
                      ElevatedButton(
                        child: const Text('alert long content'),
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
                  const SizedBox(height: 20),
                  const Text('tooltip'),
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      ElevatedButton(
                        key: btnShowMore,
                        child: const Text('show more'),
                        onPressed: () => targetShowMore(
                          context,
                          targetKey: btnShowMore,
                          size: const Size(180, 180),
                          child: Container(
                              alignment: Alignment.center,
                              child: const Text('hello world',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.none,
                                  ))),
                        ),
                      ),
                      ElevatedButton(
                        key: btnShowMoreOffset,
                        child: const Text('show more offset'),
                        onPressed: () {
                          var rect = getWidgetGlobalRect(btnShowMoreOffset);
                          showMore(
                            context,
                            size: const Size(180, 120),
                            targetRect: rect,
                            child: Container(
                                alignment: Alignment.center,
                                child: const Text('hello world',
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
                        child: const Text('show more text'),
                        onPressed: () {
                          var rect = getWidgetGlobalRect(btnShowMoreText);
                          showMoreText(
                            context,
                            targetRect: rect,
                            size: const Size(180, 120),
                            text: 'hello world',
                          );
                        },
                      ),
                      Hypertext(fontSize: 13)
                        ..moreText('more text', content: 'hello world')
                        ..moreDoc('more on doc', docName: 'privacy')
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('loading'),
                  const SizedBox(height: 20),
                  Wrap(children: [
                    ElevatedButton(
                      child: const Text('loading'),
                      onPressed: () async {
                        loading(context);
                        await Future.delayed(const Duration(seconds: 3));
                        dismiss();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('loading text'),
                      onPressed: () async {
                        loading(context, text: 'loading');
                        await Future.delayed(const Duration(seconds: 3));
                        dismiss();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('progress'),
                      onPressed: () async {
                        for (int i = 0; i <= 10; i++) {
                          await progress(context, i / 10);
                          await Future.delayed(const Duration(milliseconds: 500));
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('progress text'),
                      onPressed: () async {
                        for (int i = 0; i <= 10; i++) {
                          String text = 'preparing';
                          if (i > 5) {
                            text = 'creating';
                          }
                          await progress(context, i / 10, text: text);
                          await Future.delayed(const Duration(milliseconds: 500));
                        }
                      },
                    ),
                    ElevatedButton(
                      child: const Text('dismiss'),
                      onPressed: () => dismiss(),
                    ),
                    ElevatedButton(
                      child: const Text('toast'),
                      onPressed: () => ok(context, 'add item to cart'),
                    ),
                    ElevatedButton(
                      child: const Text('fail'),
                      onPressed: () => wrong(context, 'item already exist'),
                    ),
                    ElevatedButton(
                      child: const Text('info'),
                      onPressed: () => info(context,
                          text: 'network is slow than usual',
                          widget: const Icon(
                            CustomIcons.wifi,
                            size: 68,
                            color: Colors.blue,
                          )),
                    ),
                    ElevatedButton(
                      child: const Text('slow network'),
                      onPressed: () async {
                        loading(context);
                        await Future.delayed(const Duration(seconds: 3));
                        loading(context, text: 'network is slow');
                        await Future.delayed(const Duration(seconds: 3));
                        dismiss();
                      },
                    ),
                  ]),
                  const SizedBox(height: 20),
                  const Text('slide'),
                  const SizedBox(height: 20),
                  Wrap(children: [
                    ElevatedButton(
                      child: const Text('slide'),
                      onPressed: () => slide(
                        context,
                        const SizedBox(height: 300, child: Text('hi')),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('banner'),
                      onPressed: () => banner(
                        context,
                        'this record has been deleted',
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  const Text('route or dialog'),
                  const SizedBox(height: 20),
                  Wrap(children: [
                    ElevatedButton(
                      child: const Text('normal'),
                      onPressed: () => routeOrDialog(
                        context,
                        Container(color: Colors.blue),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('route'),
                      onPressed: () => routeOrDialog(
                        context,
                        Container(color: Colors.blue),
                        min: const Size(300, 400),
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('dialog'),
                      onPressed: () => routeOrDialog(
                        context,
                        Container(color: Colors.blue),
                        min: const Size(3000, 4000),
                      ),
                    ),
                  ]),
                ],
              ))),
    );
  }
}
