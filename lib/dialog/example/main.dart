// ignore_for_file: use_build_context_synchronously

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:libcli/delta/delta.dart' as delta;
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/generator/generator.dart' as generator;
import 'package:libcli/testing/testing.dart' as testing;
import '../dialog.dart';

main() => app.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      appName: 'dialog example',
      routesBuilder: () => {
        '/': (context, _, __) => cupertinoBottomSheet(const DialogExample()),
      },
    );

final GlobalKey btnMenu = GlobalKey();
final GlobalKey btnShowMore = GlobalKey();
final GlobalKey btnShowMoreOffset = GlobalKey();
final GlobalKey btnShowMoreText = GlobalKey();

final printers = [
  delta.ListItem<String>('1', title: 'Printer 1', icon: Icons.print, iconColor: Colors.green),
  delta.ListItem<String>('2', title: 'Printer 2', icon: Icons.print, iconColor: Colors.green),
  delta.ListItem<String>('3', title: 'Printer 3', icon: Icons.print, subtitle: 'offline'),
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
            child: _shoreMore(context),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              testing.ExampleButton(label: 'alert', builder: () => _alert(context)),
              testing.ExampleButton(label: 'tooltip', builder: () => _shoreMore(context)),
              testing.ExampleButton(label: 'toast', builder: () => _toast(context)),
              testing.ExampleButton(label: 'show popup/sheet', builder: () => _showPopupSheet(context)),
              testing.ExampleButton(label: 'banner', builder: () => _banner(context)),
              testing.ExampleButton(label: 'route', builder: () => _routeOrDialog(context)),
              testing.ExampleButton(label: 'selection', builder: () => _selection(context)),
              testing.ExampleButton(label: 'popup', builder: () => _popup(context)),
            ],
          ),
        ],
      )),
    );
  }

  Widget _popup(BuildContext context) {
    final GlobalKey btnPopup = GlobalKey();
    return ElevatedButton(
      key: btnPopup,
      child: const Text('popup'),
      onPressed: () {
        var rect = getWidgetGlobalRect(btnPopup);
        popup(context,
            rect: Rect.fromLTWH(rect.left, rect.bottom, rect.width, 200),
            child: Container(
              color: Colors.green,
              child: Center(
                  child: InkWell(
                onTap: () => debugPrint('hello'),
                child: const Text(
                  'hello',
                  style: TextStyle(fontSize: 22),
                ),
              )),
            ));
      },
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
        child: Wrap(spacing: 10, runSpacing: 10, children: [
          ElevatedButton(
            child: const Text('system dialog'),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Basic dialog title'),
                    content: const Text('A dialog is a type of modal window that\n'
                        'appears in front of app content to\n'
                        'provide critical information, or prompt\n'
                        'for a decision to be made.'),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Disable'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Enable'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ElevatedButton(
            child: const Text('alert with yes/no'),
            onPressed: () => alert('hi', type: DialogButtonsType.yesNo),
          ),
          ElevatedButton(
            child: const Text('alert title'),
            onPressed: () => alert('hi', title: 'title'),
          ),
          ElevatedButton(
            child: const Text('no barrier dismiss'),
            onPressed: () => show(textContent: 'no barrier dismiss', barrierDismissible: false),
          ),
          ElevatedButton(
            child: const Text('show error dialog'),
            onPressed: () => show(
              textContent: 'This is a error dialog',
              title: 'Oops! some thing went wrong',
              isError: true,
              type: DialogButtonsType.yesNo,
            ),
          ),
          ElevatedButton(
            child: const Text('show title/footer'),
            onPressed: () => show(
              textContent: 'hi',
              title: 'title',
              footerBuilder: (context) => const Text('footer'),
            ),
          ),
          ElevatedButton(
            child: const Text('show yes/no/cancel'),
            onPressed: () async {
              var result = await show(
                textContent: 'do you want delete this document?',
                type: DialogButtonsType.yesNoCancel,
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
            child: const Text('alert long content'),
            onPressed: () => show(
              contentBuilder: (context) => const SizedBox(
                  height: 100,
                  child: SingleChildScrollView(
                      child: Text(
                          'this is a very long content, it should cover 3 or 4 more line. we need test long message can read easily'))),
              title: 'this is a very long title. it should cover 2 line',
              iconBuilder: (context) => const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Icon(
                  Icons.alarm,
                  size: 64,
                ),
              ),
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

  Widget _shoreMore(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ElevatedButton(
          key: btnShowMore,
          child: const Text('show tooltip on target'),
          onPressed: () => showTooltipOnTarget(
            context,
            targetKey: btnShowMore,
            size: const Size(180, 180),
            child: Container(
                alignment: Alignment.center,
                child: Text('hello world', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary))),
          ),
        ),
        ElevatedButton(
          key: btnShowMoreOffset,
          child: const Text('show tooltip'),
          onPressed: () {
            var rect = getWidgetGlobalRect(btnShowMoreOffset);
            showTooltip(
              context,
              size: const Size(180, 120),
              targetRect: rect,
              child: Container(
                  alignment: Alignment.center,
                  child: Text('hello world', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary))),
            );
          },
        ),
        ElevatedButton(
          key: btnShowMoreText,
          child: const Text('show hint'),
          onPressed: () {
            var rect = getWidgetGlobalRect(btnShowMoreText);
            showHint(
              context,
              targetRect: rect,
              size: const Size(180, 120),
              text: 'hello world',
            );
          },
        ),
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
        child: const Text('error'),
        onPressed: () => toastError('item already exist'),
      ),
      ElevatedButton(
        child: const Text('info'),
        onPressed: () => toastInfo('network is slow than usual',
            widget: Icon(
              Icons.wifi,
              size: 68,
              color: Theme.of(context).colorScheme.onPrimary,
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
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
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
      ],
    );
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

  Widget _routeOrDialog(BuildContext context) {
    return Wrap(spacing: 10, runSpacing: 10, children: [
      ElevatedButton(
        child: const Text('normal'),
        onPressed: () => routeOrDialog(
          context,
          Scaffold(
            appBar: AppBar(title: const Text('normal')),
            body: Container(color: Colors.blue),
          ),
        ),
      ),
    ]);
  }

  Widget _selection(BuildContext context) {
    return Wrap(spacing: 10, runSpacing: 10, children: [
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
                delta.ListItem<String>(id, title: 'Printer $id', icon: Icons.print, iconColor: Colors.green),
              );
            },
          );
        },
      ),
    ]);
  }
}
