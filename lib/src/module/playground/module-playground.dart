import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/module/playground/wrong-provider-page.dart';

class ModulePlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            FlatButton(
              child: Text('provider with problem'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return WrongProviderPage();
                }));
              },
            ),
          ],
        ),
      ],
    );
  }
}
