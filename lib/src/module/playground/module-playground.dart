import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/module/playground/wrong-page.dart';
import 'package:libcli/src/module/playground/wait-page.dart';

class ModulePlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Wrap(
          children: [
            FlatButton(
              child: Text('provider with problem'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return WrongPage();
                }));
              },
            ),
            FlatButton(
              child: Text('provider need wait 30\'s'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return WaitPage();
                }));
              },
            ),
          ],
        ),
      ],
    ));
  }
}
