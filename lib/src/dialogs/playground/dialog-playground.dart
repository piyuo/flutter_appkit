import 'package:flutter/cupertino.dart';
import 'package:libcli/i18n.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/dialogs/dialogs.dart';
import 'package:libcli/src/dialogs/popup-menu.dart';

class DialogPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();
  final GlobalKey btnTooltip = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Dialogs(),
      child: Consumer<Dialogs>(
          builder: (context, provider, child) => Column(
                children: [
                  Wrap(
                    children: [
                      CupertinoButton(
                        child: Text('alert'),
                        onPressed: () => provider.alert(
                          context,
                          'hi',
                        ),
                      ),
                      CupertinoButton(
                        child: Text('alert icon'),
                        onPressed: () => provider.alert(context, 'hello world1',
                            icon: Icon(CupertinoIcons.exclamationmark_triangle,
                                color: CupertinoColors.systemRed, size: 38)),
                      ),
                      CupertinoButton(
                        child: Text('alert title'),
                        onPressed: () => provider.alert(context, 'hello world', title: 'title'),
                      ),
                      CupertinoButton(
                        child: Text('confirm'),
                        onPressed: () async {
                          var result = await provider.confirm(context, 'are you ok?');
                          if (result == true) {
                            provider.toast(context, 'ok');
                            return;
                          }
                          provider.toast(context, 'cancel');
                        },
                      ),
                      CupertinoButton(
                        child: Text('confirm with icon'),
                        onPressed: () async {
                          var result = await provider.confirm(
                            context,
                            'no internet, please check your connection',
                            title: 'No Internet!',
                            icon: Icon(CupertinoIcons.wifi_slash, color: CupertinoColors.systemRed, size: 38),
                            labelOK: 'retry'.i18n_,
                          );
                          if (result) {
                            provider.toast(context, 'start retry');
                          }
                        },
                      ),
                      CupertinoButton(
                        child: Text('error'),
                        onPressed: () => provider.error(context),
                      ),
                      CupertinoButton(
                        child: Text('error notified'),
                        onPressed: () => provider.error(context, notified: true),
                      ),
                      CupertinoButton(
                        child: Text('error email us'),
                        onPressed: () => provider.error(context),
                      ),
                      CupertinoButton(
                        child: Text('diskError'),
                        onPressed: () => Dialogs.of(context).alert(
                          context,
                          'diskErrorDesc'.i18n_,
                          title: 'diskError'.i18n_,
                          icon: Icon(CupertinoIcons.floppy_disk, color: CupertinoColors.systemRed, size: 38),
                        ),
                      ),
                      CupertinoButton(
                        key: btnTooltip,
                        child: Text('tooltip'),
                        onPressed: () => provider.tooltip(context, 'hello world', widgetKey: btnTooltip),
                      ),
                      CupertinoButton(
                        child: Text('toast'),
                        onPressed: () => provider.toast(context, 'hello world'),
                      ),
                      CupertinoButton(
                        child: Text('toast with icon'),
                        onPressed: () => provider.toast(context, 'hello world', icon: CupertinoIcons.question),
                      ),
                      CupertinoButton(
                        key: btnMenu,
                        child: Text('menu'),
                        onPressed: () async {
                          var item = await provider.popMenu(context, widgetKey: btnMenu, items: [
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
                          provider.toast(context, item.text);
                        },
                      ),
                    ],
                  ),
                ],
              )),
    );
  }
}
