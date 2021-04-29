import 'package:flutter/material.dart';
import 'tooltip.dart';
import 'alert.dart';
import 'popup-menu.dart';
import 'toast.dart';
import 'slide.dart';

class Playground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(1, 1), // 10% of the width, so there are ten blinds.
                colors: [const Color(0xffee0000), const Color(0xffeeee00)], // red to yellow
                tileMode: TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    ElevatedButton(
                      child: Text('alert'),
                      onPressed: () => alert(
                        context,
                        'hi',
                      ),
                    ),
                    ElevatedButton(
                      child: Text('alert warning'),
                      onPressed: () => alert(context, 'hello world1', warning: true),
                    ),
                    ElevatedButton(
                      child: Text('alert title'),
                      onPressed: () => alert(context, 'hello world', title: 'title'),
                    ),
                    ElevatedButton(
                      child: Text('alert title/footer'),
                      onPressed: () => alert(context, 'hello world', title: 'title', footer: 'footer'),
                    ),
                    ElevatedButton(
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
                          ok(context, 'yes');
                        } else if (result == false) {
                          ok(context, 'no');
                        } else if (result == null) {
                          ok(context, 'cancel');
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text('alert ok/cancel'),
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
                      child: Text('alert warning email us'),
                      onPressed: () =>
                          alert(context, 'error message', footer: 'description', emailUs: true, warning: true),
                    ),
                    ElevatedButton(
                      child: Text('alert long content'),
                      onPressed: () => alert(
                        context,
                        'this is a very long content, it should cover 3 or 4 more line. we need test long message can read easily',
                        title: 'this is a very long title. it should cover 2 line',
                        footer:
                            'this is a very long footer, it should cover 3 or 4 more line. we need test long message can read easily',
                        emailUs: true,
                        icon: Icons.sync_problem_rounded,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('tooltip'),
                SizedBox(height: 20),
                Wrap(
                  children: [
                    ElevatedButton(
                      key: btnTooltip,
                      child: Text('tooltip'),
                      onPressed: () => tip(context, 'hello world', widgetKey: btnTooltip),
                    ),
                    ElevatedButton(
                      key: btnMenu,
                      child: Text('tool'),
                      onPressed: () async {
                        var item = await tool(context, widgetKey: btnMenu, items: [
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
                        ok(context, item.text);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('loading'),
                SizedBox(height: 20),
                Wrap(children: [
                  ElevatedButton(
                    child: Text('loading'),
                    onPressed: () => loading(context),
                  ),
                  ElevatedButton(
                    child: Text('progress'),
                    onPressed: () async {
                      for (int i = 0; i <= 10; i++) {
                        await progress(context, i / 10);
                        await Future.delayed(Duration(milliseconds: 500));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('dismiss'),
                    onPressed: () => dismiss(),
                  ),
                  ElevatedButton(
                    child: Text('toast'),
                    onPressed: () => ok(context, 'add item to cart'),
                  ),
                  ElevatedButton(
                    child: Text('fail'),
                    onPressed: () => wrong(context, 'item already exist'),
                  ),
                  ElevatedButton(
                    child: Text('info'),
                    onPressed: () => info(context,
                        text: 'network is slow than usual',
                        widget: Icon(
                          Icons.wifi,
                          size: 68,
                          color: Theme.of(context).accentColor,
                        )),
                  ),
                ]),
                SizedBox(height: 20),
                Text('slide'),
                SizedBox(height: 20),
                Wrap(children: [
                  ElevatedButton(
                    child: Text('slide'),
                    onPressed: () => slide(
                      context,
                      Container(height: 300, child: Text('hi')),
                    ),
                  ),
                ]),
              ],
            )));
  }
}
