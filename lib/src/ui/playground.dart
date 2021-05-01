import 'package:flutter/material.dart';
import 'playground-provider.dart';
import 'hypertext/hypertext.dart';
import 'package:provider/provider.dart';

class WidgetsPlayground extends StatelessWidget {
  Widget hyperText(BuildContext context) {
    return HyperText()
      ..span('HELLO THIS IS MY ')
      ..link('LONG', onTap: (_) => print('hello'))
      ..bold(' remember ')
      ..tip('learn more', 'hello learn more')
      ..span(' SENTENCE ')
      ..doc('privacy', 'privacy');
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => WidgetsPlaygroundProvider(),
      child: Consumer<WidgetsPlaygroundProvider>(
        builder: (context, provider, child) => Scaffold(
            body: Column(
          children: [
            Wrap(
              children: [
                hyperText(context),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
