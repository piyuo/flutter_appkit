import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/gallery/gallery.dart' as gallery;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/unique/unique.dart' as unique;
import 'package:libcli/testing/testing.dart' as testing;
import '../dialog.dart';

main() => app.start(
      appName: 'dialog',
      routes: {
        '/': (context, state, data) => const DialogExample(),
      },
    );

final GlobalKey btnMenu = GlobalKey();
final GlobalKey btnShowMore = GlobalKey();
final GlobalKey btnShowMoreOffset = GlobalKey();
final GlobalKey btnShowMoreText = GlobalKey();

final printers = [
  gallery.ListItem<String>('1', title: 'Printer 1', icon: Icons.print, iconColor: Colors.green),
  gallery.ListItem<String>('2', title: 'Printer 2', icon: Icons.print, iconColor: Colors.green),
  gallery.ListItem<String>('3', title: 'Printer 3', icon: Icons.print, subtitle: 'offline'),
];

class DialogExample extends StatelessWidget {
  const DialogExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: _slide(context),
          ),
          Wrap(
            children: [
              testing.example(
                context,
                text: 'alert',
                child: _alert(context),
              ),
              testing.example(
                context,
                text: 'tooltip',
                child: _tooltip(context),
              ),
              testing.example(
                context,
                text: 'loading',
                child: _loading(context),
              ),
              testing.example(
                context,
                text: 'slide',
                child: _slide(context),
              ),
              testing.example(
                context,
                text: 'route',
                child: _route(context),
              ),
              testing.example(
                context,
                text: 'selection',
                child: _selection(context),
              ),
            ],
          ),
        ],
      )),
    );
  }

  Widget _alert(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
            colors: [Color(0xffee0000), Color(0xffeeee00)], // red to yellow
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
        ),
        child: Wrap(children: [
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
                toastDone(context, text: 'yes');
              } else if (result == false) {
                toastDone(context, text: 'no');
              } else if (result == null) {
                toastDone(context, text: 'cancel');
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
                toastDone(context, text: 'ok');
              } else if (result == null) {
                toastDone(context, text: 'cancel');
              }
            },
          ),
          ElevatedButton(
            child: const Text('alert warning email us'),
            onPressed: () => alert(context, 'error message', footer: 'description', emailUs: true, warning: true),
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
        ]));
  }

  Widget _tooltip(BuildContext context) {
    return Wrap(
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
    );
  }

  Widget _loading(BuildContext context) {
    return Wrap(children: [
      ElevatedButton(
        child: const Text('searching'),
        onPressed: () async {
          toastSearching(context, text: 'Searching ...');
          await Future.delayed(const Duration(seconds: 3));
          dismiss();
        },
      ),
      ElevatedButton(
        child: const Text('Done'),
        onPressed: () async {
          toastDone(context);
        },
      ),
      ElevatedButton(
        child: const Text('with loading'),
        onPressed: () async {
          withLoading(context, () async {
            await Future.delayed(const Duration(seconds: 3));
          });
        },
      ),
      ElevatedButton(
        child: const Text('with loading then done'),
        onPressed: () async {
          withLoadingThenDone(context, () async {
            await Future.delayed(const Duration(seconds: 3));
            return true;
          });
        },
      ),
      ElevatedButton(
        child: const Text('toast loading'),
        onPressed: () async {
          toastLoading(context);
          await Future.delayed(const Duration(seconds: 3));
          dismiss();
        },
      ),
      ElevatedButton(
        child: const Text('toast loading then OK'),
        onPressed: () async {
          toastLoading(context);
          await Future.delayed(const Duration(seconds: 1));
          dismiss();
          toastDone(context);
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
        onPressed: () => toastDone(context, text: 'add item to cart'),
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
    ]);
  }

  Widget _slide(BuildContext context) {
    return Wrap(children: [
      ElevatedButton(
        child: const Text('show sheet'),
        onPressed: () => showSheet(
          context,
          child: Column(children: [
            const SizedBox(height: 30),
            SizedBox(
                height: 80,
                child: ElevatedButton(
                  child: const Text('close'),
                  onPressed: () => Navigator.pop(context),
                )),
            const SizedBox(height: 20),
            const SizedBox(height: 80, child: Placeholder()),
            const SizedBox(height: 20),
            const SizedBox(height: 80, child: Placeholder()),
            const SizedBox(height: 120),
          ]),
        ),
      ),
      ElevatedButton(
        child: const Text('banner'),
        onPressed: () => banner(
          context,
          const Text(
            'this record has been deleted',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          leading: const Icon(Icons.warning, color: Colors.black),
        ),
      ),
    ]);
  }

  Widget _route(BuildContext context) {
    return Wrap(children: [
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
    ]);
  }

  Widget _selection(BuildContext context) {
    return Wrap(children: [
      ElevatedButton(
        child: const Text('single selection'),
        onPressed: () async {
          final result = await showSingleSelection<String>(context, title: 'select a bluetooth printer', items: {
            '1': 'printer 1',
            '2': 'printer 2',
          });
          debugPrint(result);
        },
      ),
      ElevatedButton(
        child: const Text('check list dialog'),
        onPressed: () async {
          await showCheckList<String>(
            context,
            title: 'printers',
            items: printers,
            hint: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 200, 0, 200),
              child: const Text('Tap on button to add printer'),
            ),
            onRefresh: () async => [...printers],
            onDelete: (List<String> keys) async {
              for (int i = printers.length - 1; i >= 0; i--) {
                if (keys.contains(printers[i].key)) {
                  printers.removeAt(i);
                }
              }
            },
            onItemTap: (String key) async {
              if (printers.isNotEmpty) {
                printers.removeAt(0);
              }
            },
            onNewItem: () async {
              final id = unique.randomNumber(5);
              printers.add(
                gallery.ListItem<String>(id, title: 'Printer $id', icon: Icons.print, iconColor: Colors.green),
              );
            },
          );
        },
      ),
    ]);
  }
}
