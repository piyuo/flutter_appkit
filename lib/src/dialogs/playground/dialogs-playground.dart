import 'package:flutter/material.dart';
import 'package:libcli/src/i18n/i18n.dart';
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
                      child: Text('alert warning'),
                      onPressed: () => alert(context, 'hello world1', warning: true),
                    ),
                    RaisedButton(
                      child: Text('alert title'),
                      onPressed: () => alert(context, 'hello world', title: 'title'),
                    ),
                    RaisedButton(
                      child: Text('alert title/footer'),
                      onPressed: () => alert(context, 'hello world', title: 'title', footer: 'footer'),
                    ),
                    RaisedButton(
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
                          toast(context, 'yes');
                        } else if (result == false) {
                          toast(context, 'no');
                        } else if (result == null) {
                          toast(context, 'cancel');
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text('alert ok/cancel'),
                      onPressed: () async {
                        var result = await alert(
                          context,
                          'save this document?',
                          buttonSave: true,
                          buttonCancel: true,
                        );
                        if (result == true) {
                          toast(context, 'ok');
                        } else if (result == null) {
                          toast(context, 'cancel');
                        }
                      },
                    ),
                    RaisedButton(
                      child: Text('alert warning emailus'),
                      onPressed: () =>
                          alert(context, 'error message', footer: 'description', emailUs: true, warning: true),
                    ),
                    RaisedButton(
                      child: Text('alert long content'),
                      onPressed: () => alert(
                        context,
                        'this is a very long content, it should cover 3 or 4 more line. we need test long messsage can read easilly',
                        title: 'this is a very long title. it should cover 2 line',
                        footer:
                            'this is a very long footer, it should cover 3 or 4 more line. we need test long messsage can read easilly',
                        emailUs: true,
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
