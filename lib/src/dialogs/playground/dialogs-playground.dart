import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/alert.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';

class DialogsPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
                colors: [const Color(0xffee0000), const Color(0xffeeee00)], // red to yellow
                tileMode: TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: Column(
              children: [
                Wrap(
                  children: [
                    RaisedButton(
                      child: Text('alert'),
                      onPressed: () => alert(
                        context,
                        'hi',
                      ),
                    ),
                    RaisedButton(
                      child: Text('alert icon'),
                      onPressed: () => alert(context, 'hello world1', warning: true),
                    ),
                    RaisedButton(
                      child: Text('alert title'),
                      onPressed: () => alert(context, 'hello world', title: 'title'),
                    ),
                    RaisedButton(
                      child: Text('alert delete/cancel'),
                      onPressed: () async {
                        var result = await alert(
                          context,
                          'do you want delete this document?',
                          buttonType: ButtonType.deleteCancel,
                          colorTrue: Colors.red,
                        );
                        if (result == true) {
                          toast(context, 'ok');
                          return;
                        }
                        toast(context, 'cancel');
                      },
                    ),
                    RaisedButton(
                      child: Text('alert save/cancel'),
                      onPressed: () async {
                        var result = await alert(
                          context,
                          'do you want save this document?',
                          buttonType: ButtonType.saveCancel,
                          colorTrue: Colors.greenAccent,
                        );
                        if (result == true) {
                          toast(context, 'ok');
                          return;
                        }
                        toast(context, 'cancel');
                      },
                    ),
                    RaisedButton(
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
                    RaisedButton(
                      child: Text('alert yes/no with icon'),
                      onPressed: () async {
                        var result = await alert(
                          context,
                          'no internet, please check your connection',
                          title: 'No Internet!',
                          icon: Icons.wifi_off_outlined,
                          buttonType: ButtonType.retryCancel,
                        );
                        if (result) {
                          toast(context, 'start retry');
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text('alert description'),
                      onPressed: () => alert(context, 'error message', footer: 'description'),
                    ),
                    RaisedButton(
                      child: Text('alert desc emailus'),
                      onPressed: () => alert(context, 'error message', footer: 'description', emailUs: true),
                    ),
                    RaisedButton(
                      child: Text('alert emailus'),
                      onPressed: () => alert(context, 'error message', footer: 'description', emailUs: true),
                    ),
                    RaisedButton(
                      child: Text('diskError'),
                      onPressed: () => alert(
                        context,
                        'diskErrorDesc'.i18n_,
                        title: 'diskError'.i18n_,
                        icon: Icons.sync_problem_rounded,
                      ),
                    ),
                    RaisedButton(
                      key: btnTooltip,
                      child: Text('tooltip'),
                      onPressed: () => tooltip(context, 'hello world', widgetKey: btnTooltip),
                    ),
                    RaisedButton(
                      child: Text('toast'),
                      onPressed: () => toast(context, 'hello world'),
                    ),
                    RaisedButton(
                      child: Text('toast with icon'),
                      onPressed: () =>
                          toast(context, 'hello world', icon: Icon(Icons.check, size: 38, color: Colors.white)),
                    ),
                    RaisedButton(
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
            )));
  }
}
