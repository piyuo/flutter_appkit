// ignore_for_file: use_build_context_synchronously

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/layout/layout.dart' as layout;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/generator/generator.dart' as generator;
import 'package:libcli/testing/testing.dart' as testing;
import '../dialog.dart';

main() => app.start(
      appName: 'dialog',
      routes: {
        '/': (context, state, data) => cupertinoBottomSheet(const DialogExample()),
      },
    );

final GlobalKey btnMenu = GlobalKey();
final GlobalKey btnShowMore = GlobalKey();
final GlobalKey btnShowMoreOffset = GlobalKey();
final GlobalKey btnShowMoreText = GlobalKey();

final printers = [
  layout.ListItem<String>('1', title: 'Printer 1', icon: Icons.print, iconColor: Colors.green),
  layout.ListItem<String>('2', title: 'Printer 2', icon: Icons.print, iconColor: Colors.green),
  layout.ListItem<String>('3', title: 'Printer 3', icon: Icons.print, subtitle: 'offline'),
];

class DialogExample extends StatelessWidget {
  const DialogExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: _alert(context),
          ),
          Wrap(
            children: [
              testing.ExampleButton(label: 'alert', builder: () => _alert(context)),
              testing.ExampleButton(label: 'tooltip', builder: () => _tooltip(context)),
              testing.ExampleButton(label: 'toast', builder: () => _toast(context)),
              testing.ExampleButton(label: 'show popup/sheet', builder: () => _showPopupSheet(context)),
              testing.ExampleButton(label: 'banner', builder: () => _banner(context)),
              testing.ExampleButton(label: 'route', builder: () => _route(context)),
              testing.ExampleButton(label: 'selection', builder: () => _selection(context)),
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
            onPressed: () => alert('hi', showCancel: true),
          ),
          ElevatedButton(
            child: const Text('alert title'),
            onPressed: () => alert('hi', title: 'title'),
          ),
          ElevatedButton(
            child: const Text('show no blurry'),
            onPressed: () => show(textContent: 'hi', blurry: false),
          ),
          ElevatedButton(
            child: const Text('show warning'),
            onPressed: () => show(textContent: 'hi', warning: true),
          ),
          ElevatedButton(
            child: const Text('show title/footer'),
            onPressed: () => show(textContent: 'hi', title: 'title', footer: 'footer'),
          ),
          ElevatedButton(
            child: const Text('show yes/no/cancel'),
            onPressed: () async {
              var result = await show(
                textContent: 'do you want delete this document?',
                showYes: true,
                showNo: true,
                showCancel: true,
              );
              if (result == true) {
                toastDone(text: 'yes');
              } else if (result == false) {
                toastDone(text: 'no');
              } else if (result == null) {
                toastDone(text: 'cancel');
              }
            },
          ),
          ElevatedButton(
            child: const Text('confirm'),
            onPressed: () async {
              var result = await confirm(
                'save this document?',
              );
              if (result == true) {
                toastDone(text: 'ok');
              } else if (result == null) {
                toastDone(text: 'cancel');
              }
            },
          ),
          ElevatedButton(
            child: const Text('alert warning email us'),
            onPressed: () => show(textContent: 'error message', footer: 'description', emailUs: true, warning: true),
          ),
          ElevatedButton(
            child: const Text('alert long content'),
            onPressed: () => show(
              content: const SizedBox(
                  height: 30,
                  child: SingleChildScrollView(
                      child: Text(
                          'this is a very long content, it should cover 3 or 4 more line. we need test long message can read easily'))),
              title: 'this is a very long title. it should cover 2 line',
              footer:
                  'this is a very long footer, it should cover 3 or 4 more line. we need test long message can read easily',
              emailUs: true,
              icon: Icons.alarm,
            ),
          ),
          ElevatedButton(
            child: const Text('prompt'),
            onPressed: () async {
              final text = await prompt(
                label: 'Your name',
                initialValue: 'John',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              );
              debugPrint('$text');
            },
          ),
          ElevatedButton(
            child: const Text('promptInt'),
            onPressed: () async {
              final number = await promptInt(
                label: 'Quantity',
                maxLength: 2,
              );
              debugPrint('$number');
            },
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

  Widget _toast(BuildContext context) {
    return Wrap(children: [
      ElevatedButton(
        child: const Text('Done'),
        onPressed: () async {
          toastDone();
        },
      ),
      ElevatedButton(
        child: const Text('mask'),
        onPressed: () async {
          toastMask();
          await Future.delayed(const Duration(seconds: 3));
          dismissToast();
        },
      ),
      ElevatedButton(
        child: const Text('wait for'),
        onPressed: () async {
          toastWaitFor(
            callback: () async {
              await Future.delayed(const Duration(seconds: 3));
            },
          );
        },
      ),
      ElevatedButton(
        child: const Text('toast wait'),
        onPressed: () async {
          toastWait();
          await Future.delayed(const Duration(seconds: 3));
          dismissToast();
        },
      ),
      ElevatedButton(
        child: const Text('toast wait then OK'),
        onPressed: () async {
          toastWait();
          await Future.delayed(const Duration(seconds: 1));
          dismissToast();
          toastDone();
        },
      ),
      ElevatedButton(
        child: const Text('loading text'),
        onPressed: () async {
          toastWait(text: 'loading');
          await Future.delayed(const Duration(seconds: 3));
          dismissToast();
        },
      ),
      ElevatedButton(
        child: const Text('progress'),
        onPressed: () async {
          for (int i = 0; i <= 10; i++) {
            toastProgress(i / 10);
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
            toastProgress(i / 10, text: text);
            await Future.delayed(const Duration(milliseconds: 500));
          }
        },
      ),
      ElevatedButton(
        child: const Text('dismiss'),
        onPressed: () => dismissToast(),
      ),
      ElevatedButton(
        child: const Text('toast'),
        onPressed: () => toastDone(text: 'add item to cart'),
      ),
      ElevatedButton(
        child: const Text('fail'),
        onPressed: () => toastError('item already exist'),
      ),
      ElevatedButton(
        child: const Text('info'),
        onPressed: () => toastInfo('network is slow than usual',
            widget: const Icon(
              Icons.wifi,
              size: 68,
              color: Colors.blue,
            )),
      ),
      ElevatedButton(
        child: const Text('slow network'),
        onPressed: () async {
          toastWait();
          await Future.delayed(const Duration(seconds: 3));
          toastWait(text: 'network is slow');
          await Future.delayed(const Duration(seconds: 3));
          dismissToast();
        },
      ),
    ]);
  }

  Widget _showPopupSheet(BuildContext context) {
    return Wrap(children: [
      ElevatedButton(
        child: const Text('show popup'),
        onPressed: () => showPopup(
          context,
          padding: const EdgeInsets.only(top: 20),
          //maxHeight: 100,
          bottomBuilder: (context) => Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                  child: ElevatedButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ))),
          itemBuilder: (context, index) => Column(
            children: const [
              SizedBox(height: 180, child: Placeholder()),
              SizedBox(height: 20),
              Text('hello world'),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      ElevatedButton(
        child: const Text('show scroll popup'),
        onPressed: () => showPopup(
          context,
          itemCount: 11,
          itemBuilder: (context, index) => const [
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            Text('hello world'),
            SizedBox(height: 20),
          ][index],
        ),
      ),
      ElevatedButton(
        child: const Text('show sheet'),
        onPressed: () => showSheet(
          context,
          padding: const EdgeInsets.only(top: 20),
//          maxHeight: 100,
          bottomBuilder: (context) => Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                  child: ElevatedButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ))),
//          backgroundColor: Colors.red,
          itemBuilder: (context, _) => Column(
            children: [
              const SizedBox(height: 180, child: Placeholder()),
              const Text('hello world'),
              const SizedBox(height: 20),
              ElevatedButton(
                  child: const Text('show sheet'),
                  onPressed: () => showSheet(
                        context,
                        fromRoot: false,
                        heightFactor: 0.95,
                        itemBuilder: (context, _) => const Text('hello'),
                      ))
            ],
          ),
        ),
      ),
      ElevatedButton(
        child: const Text('show scroll sheet'),
        onPressed: () => showSheet(
          context,
          heightFactor: 0.8,
          itemCount: 11,
          itemBuilder: (context, index) => const [
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            SizedBox(height: 20),
            SizedBox(height: 180, child: Placeholder()),
            Text('hello world'),
            SizedBox(height: 20),
          ][index],
        ),
      ),
      ElevatedButton(
        child: const Text('show side'),
        onPressed: () => showSide(
          context,
          color: Colors.green.shade300,
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
    ]);
  }

  Widget _banner(BuildContext context) {
    return Wrap(children: [
      ElevatedButton(
        child: const Text('show banner'),
        onPressed: () => showBanner(
          const Text(
            'this record has been deleted',
          ),
        ),
      ),
      ElevatedButton(
        child: const Text('show warning banner'),
        onPressed: () => showWarningBanner('This is warning banner'),
      ),
      ElevatedButton(
        child: const Text('show info banner'),
        onPressed: () => showInfoBanner('This is info banner'),
      ),
      ElevatedButton(
        child: const Text('dismiss banner'),
        onPressed: () => dismissBanner(context),
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
              final id = generator.randomNumber(5);
              printers.add(
                layout.ListItem<String>(id, title: 'Printer $id', icon: Icons.print, iconColor: Colors.green),
              );
            },
          );
        },
      ),
    ]);
  }
}
