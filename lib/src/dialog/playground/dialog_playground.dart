import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/dialog.dart' as dialog;

class DialogPlayground extends StatelessWidget {
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Wrap(
              children: [
                RaisedButton(
                    child: Text('alert'),
                    onPressed: () async {
                      await dialog.alert(context, 'message', title: 'title');
                      dialog.hint(context, 'dialog closed');
                    }),
                RaisedButton(
                    child: Text('error'),
                    onPressed: () async {
                      await dialog.error(context, 'error code');
                      dialog.hint(context, 'dialog closed');
                    }),
                RaisedButton(
                    child: Text('hint'),
                    onPressed: () {
                      dialog.hint(context, 'your network is slow than usual',
                          icon: Icons.cloud);
                    }),
                RaisedButton(
                    child: Text('choice'),
                    onPressed: () async {
                      var result = await dialog.choice(
                        context,
                        'How are you?',
                        title: 'Hi',
                        ok: 'Fine',
                      );
                      switch (result) {
                        case true:
                          dialog.hint(context, 'fine');
                          break;
                        case false:
                          dialog.hint(context, 'cancel');
                          break;
                        default:
                          dialog.hint(context, 'don\'t know');
                          break;
                      }
                    }),
                RaisedButton(
                    child: Text('confirm'),
                    onPressed: () async {
                      var result = await dialog.confirm(context, 'hello');
                      switch (result) {
                        case true:
                          dialog.hint(context, 'ok');
                          break;
                        case false:
                          dialog.hint(context, 'cancel');
                          break;
                        default:
                          dialog.hint(context, 'close');
                          break;
                      }
                    }),
                RaisedButton(
                    key: btnKey,
                    child: Text('pop text'),
                    onPressed: () async {
                      dialog.tip(
                          context,
                          //'you can mark your computer or mobile device as trusted. With trusted computers and devices, you don’t need to enter a verification code each time you sign in',
                          '您可以將計算機或移動設備標記為受信任。 使用受信任的計算機和設備，您無需每次登錄都輸入驗證碼。',
                          targetKey: btnKey);
                    }),
                RaisedButton(
                    key: btnKey2,
                    child: Text('pop menu'),
                    onPressed: () async {
                      dialog.menu(context, items: [
                        dialog.MenuItem(
                            id: 'home',
                            title: 'Home',
                            widget: Icon(
                              Icons.home,
                              color: Colors.white,
                            )),
                        dialog.MenuItem(
                            id: 'mail',
                            title: 'Mail',
                            widget: Icon(
                              Icons.mail,
                              color: Colors.white,
                            )),
                        dialog.MenuItem(
                            id: 'power',
                            title: 'Power',
                            widget: Icon(
                              Icons.power,
                              color: Colors.white,
                            )),
                        dialog.MenuItem(
                            id: 'setting',
                            title: 'Setting',
                            widget: Icon(
                              Icons.settings,
                              color: Colors.white,
                            )),
                      ], onPressed: (item) {
                        print('${item.id} clicked');
                      }, targetKey: btnKey2);
                    }),
              ],
            ),
          ],
        ));
  }
}
