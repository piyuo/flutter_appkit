import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/module/playground/wrong-provider-page.dart';

class ModulePlayground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            CupertinoButton(
              child: Text('provider with problem'),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
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
