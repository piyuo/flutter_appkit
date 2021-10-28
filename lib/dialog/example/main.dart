import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/app/app.dart' as app;
import '../src/alert.dart';
import '../src/toast.dart';
import '../src/slide.dart';
import '../src/route.dart';
import '../src/show_more.dart';
import '../src/banner.dart';
import '../src/hypertext.extension.dart';
import '../src/single_selection.dart';

main() => app.start(
      appName: 'dialog example',
      routes: (_) => const DialogExample(),
    );

final GlobalKey btnMenu = GlobalKey();
final GlobalKey btnShowMore = GlobalKey();
final GlobalKey btnShowMoreOffset = GlobalKey();
final GlobalKey btnShowMoreText = GlobalKey();

class DialogExample extends StatelessWidget {
  const DialogExample({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
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
                                toastOK(context, 'yes');
                              } else if (result == false) {
                                toastOK(context, 'no');
                              } else if (result == null) {
                                toastOK(context, 'cancel');
                              }
                            },
                          ),
                          ElevatedButton(
                            child: const Text('confirm'),
                            onPressed: () async {
                              var result = await confirm(
                                context,
                                'save this document?',
                              );
                              if (result == true) {
                                toastOK(context, 'ok');
                              } else if (result == null) {
                                toastOK(context, 'cancel');
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
                              icon: Icons.alarm,
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
                              var rect = delta.getWidgetGlobalRect(btnShowMoreOffset);
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
                              var rect = delta.getWidgetGlobalRect(btnShowMoreText);
                              showMoreText(
                                context,
                                targetRect: rect,
                                size: const Size(180, 120),
                                text: 'hello world',
                              );
                            },
                          ),
                          delta.Hypertext(fontSize: 13)
                            ..moreText('more text', content: 'hello world')
                            ..moreDoc('more on doc', docName: 'privacy')
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('loading'),
                      const SizedBox(height: 20),
                      Wrap(children: [
                        ElevatedButton(
                          child: const Text('searching'),
                          onPressed: () async {
                            toastLoading(context, text: 'Searching ...', searching: true);
                            await Future.delayed(const Duration(seconds: 3));
                            dismiss();
                          },
                        ),
                        ElevatedButton(
                          child: const Text('loading'),
                          onPressed: () async {
                            toastLoading(context);
                            await Future.delayed(const Duration(seconds: 3));
                            dismiss();
                          },
                        ),
                        ElevatedButton(
                          child: const Text('loading text'),
                          onPressed: () async {
                            toastLoading(context, text: 'loading');
                            await Future.delayed(const Duration(seconds: 3));
                            dismiss();
                          },
                        ),
                        ElevatedButton(
                          child: const Text('progress'),
                          onPressed: () async {
                            for (int i = 0; i <= 10; i++) {
                              await toastProgress(context, i / 10);
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
                              await toastProgress(context, i / 10, text: text);
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
                          onPressed: () => toastOK(context, 'add item to cart'),
                        ),
                        ElevatedButton(
                          child: const Text('fail'),
                          onPressed: () => toastError(context, 'item already exist'),
                        ),
                        ElevatedButton(
                          child: const Text('info'),
                          onPressed: () => toastInfo(context,
                              text: 'network is slow than usual',
                              widget: const Icon(
                                Icons.wifi,
                                size: 68,
                                color: Colors.blue,
                              )),
                        ),
                        ElevatedButton(
                          child: const Text('slow network'),
                          onPressed: () async {
                            toastLoading(context);
                            await Future.delayed(const Duration(seconds: 3));
                            toastLoading(context, text: 'network is slow');
                            await Future.delayed(const Duration(seconds: 3));
                            dismiss();
                          },
                        ),
                        ElevatedButton(
                          child: const Text('bluetooth'),
                          onPressed: () async {
                            toastBluetoothSearching(context, text: 'searching paired bluetooth printer');
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
                      const SizedBox(height: 20),
                      const Text('selection'),
                      const SizedBox(height: 20),
                      Wrap(children: [
                        ElevatedButton(
                          child: const Text('single selection'),
                          onPressed: () async {
                            final result = await singleSelection<String>(
                              context,
                              title: 'select a bluetooth printer',
                              items: {
                                '1': 'printer 1',
                                '2': 'printer 2',
                              },
                              onRefresh: (BuildContext context) async {
                                return {
                                  '1': 'printer 1',
                                  '2': 'printer 2',
                                  '3': 'printer 3',
                                };
                              },
                            );
                            debugPrint(result);
                          },
                        ),
                      ]),
                    ],
                  )))),
    );
  }
}
