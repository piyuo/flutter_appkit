import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';

class DialogsPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            CupertinoButton(
              child: Text('alert'),
              onPressed: () => alert(
                context,
                'hi',
              ),
            ),
            CupertinoButton(
              child: Text('alert icon'),
              onPressed: () => alert(context, 'hello world1',
                  icon: Icon(CupertinoIcons.exclamationmark_triangle, color: CupertinoColors.systemRed, size: 38)),
            ),
            CupertinoButton(
              child: Text('alert title'),
              onPressed: () => alert(context, 'hello world', title: 'title'),
            ),
            CupertinoButton(
              child: Text('confirm'),
              onPressed: () async {
                var result = await confirm(context, 'are you ok?');
                if (result == true) {
                  toast(context, 'ok');
                  return;
                }
                toast(context, 'cancel');
              },
            ),
            CupertinoButton(
              child: Text('confirm with icon'),
              onPressed: () async {
                var result = await confirm(
                  context,
                  'no internet, please check your connection',
                  title: 'No Internet!',
                  icon: Icon(CupertinoIcons.wifi_slash, color: CupertinoColors.systemRed, size: 38),
                  labelOK: 'retry'.i18n_,
                );
                if (result) {
                  toast(context, 'start retry');
                }
              },
            ),
            CupertinoButton(
              child: Text('alert description'),
              onPressed: () => alert(context, 'error message', description: 'description'),
            ),
            CupertinoButton(
              child: Text('alert desc emailus'),
              onPressed: () => alert(context, 'error message', description: 'description', emailUs: true),
            ),
            CupertinoButton(
              child: Text('alert emailus'),
              onPressed: () => alert(context, 'error message', description: 'description', emailUs: true),
            ),
            CupertinoButton(
              child: Text('diskError'),
              onPressed: () => alert(
                context,
                'diskErrorDesc'.i18n_,
                title: 'diskError'.i18n_,
                icon: Icon(CupertinoIcons.floppy_disk, color: CupertinoColors.systemRed, size: 38),
              ),
            ),
            CupertinoButton(
              key: btnTooltip,
              child: Text('tooltip'),
              onPressed: () => tooltip(context, 'hello world', widgetKey: btnTooltip),
            ),
            CupertinoButton(
              child: Text('toast'),
              onPressed: () => toast(context, 'hello world'),
            ),
            CupertinoButton(
              child: Text('toast with icon'),
              onPressed: () => toast(context, 'hello world',
                  icon: Icon(CupertinoIcons.question, size: 38, color: CupertinoColors.white)),
            ),
            CupertinoButton(
              key: btnMenu,
              child: Text('menu'),
              onPressed: () async {
                var item = await popMenu(context, widgetKey: btnMenu, items: [
                  MenuItem(
                      id: 'home',
                      text: 'Home',
                      widget: Icon(
                        CupertinoIcons.home,
                        color: CupertinoColors.white,
                      )),
                  MenuItem(
                      id: 'mail',
                      text: 'Mail',
                      widget: Icon(
                        CupertinoIcons.envelope,
                        color: CupertinoColors.white,
                      )),
                  MenuItem(
                      id: 'power',
                      text: 'Power',
                      widget: Icon(
                        CupertinoIcons.power,
                        color: CupertinoColors.white,
                      )),
                  MenuItem(
                      id: 'setting',
                      text: 'Setting',
                      widget: Icon(
                        CupertinoIcons.settings,
                        color: CupertinoColors.white,
                      )),
                ]);
                toast(context, item.text);
              },
            ),
          ],
        ),
      ],
    );
  }
}
