import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:libcli/src/dialog/dialog.dart' as dialog;

class DialogPlayground extends StatelessWidget {
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
              ],
            ),
          ],
        ));
  }
}
