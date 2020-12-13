import 'package:flutter/material.dart';
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
            FlatButton(
              child: Text('alert'),
              onPressed: () => alert(
                context,
                'hi',
              ),
            ),
            FlatButton(
              child: Text('alert icon'),
              onPressed: () => alert(context, 'hello world1',
                  icon: Icon(
                    Icons.warning_outlined,
                    color: Colors.redAccent,
                    size: 38,
                  )),
            ),
            FlatButton(
              child: Text('alert title'),
              onPressed: () => alert(context, 'hello world', title: 'title'),
            ),
            FlatButton(
              child: Text('alert ok/cancel'),
              onPressed: () async {
                var result = await alert(context, 'are you ok?', buttonType: ButtonType.okCancel);
                if (result == true) {
                  toast(context, 'ok');
                  return;
                }
                toast(context, 'cancel');
              },
            ),
            FlatButton(
              child: Text('alert yes/no with icon'),
              onPressed: () async {
                var result = await alert(
                  context,
                  'no internet, please check your connection',
                  title: 'No Internet!',
                  icon: Icon(Icons.wifi_off_outlined, color: Colors.redAccent, size: 38),
                  buttonType: ButtonType.retryCancel,
                );
                if (result) {
                  toast(context, 'start retry');
                }
              },
            ),
            FlatButton(
              child: Text('alert description'),
              onPressed: () => alert(context, 'error message', description: 'description'),
            ),
            FlatButton(
              child: Text('alert desc emailus'),
              onPressed: () => alert(context, 'error message', description: 'description', emailUs: true),
            ),
            FlatButton(
              child: Text('alert emailus'),
              onPressed: () => alert(context, 'error message', description: 'description', emailUs: true),
            ),
            FlatButton(
              child: Text('diskError'),
              onPressed: () => alert(
                context,
                'diskErrorDesc'.i18n_,
                title: 'diskError'.i18n_,
                icon: Icon(Icons.sync_problem_rounded, color: Colors.redAccent, size: 38),
              ),
            ),
            FlatButton(
              key: btnTooltip,
              child: Text('tooltip'),
              onPressed: () => tooltip(context, 'hello world', widgetKey: btnTooltip),
            ),
            FlatButton(
              child: Text('toast'),
              onPressed: () => toast(context, 'hello world'),
            ),
            FlatButton(
              child: Text('toast with icon'),
              onPressed: () => toast(context, 'hello world', icon: Icon(Icons.check, size: 38, color: Colors.white)),
            ),
            FlatButton(
              key: btnMenu,
              child: Text('menu'),
              onPressed: () async {
                var item = await popMenu(context, widgetKey: btnMenu, items: [
                  MenuItem(
                      id: 'home',
                      text: 'Home',
                      widget: Icon(
                        Icons.home,
                        color: Colors.white,
                      )),
                  MenuItem(
                      id: 'mail',
                      text: 'Mail',
                      widget: Icon(
                        Icons.mail_outline,
                        color: Colors.white,
                      )),
                  MenuItem(
                      id: 'power',
                      text: 'Power',
                      widget: Icon(
                        Icons.power,
                        color: Colors.white,
                      )),
                  MenuItem(
                      id: 'setting',
                      text: 'Setting',
                      widget: Icon(
                        Icons.settings,
                        color: Colors.white,
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
