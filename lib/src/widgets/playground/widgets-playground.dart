import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/playground/widgets-playground-provider.dart';
import 'package:libcli/src/widgets/hypertext/hyper-text.dart';
import 'package:libcli/src/widgets/simple/simple-email-field.dart';
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

  Widget signInField(BuildContext context, WidgetsPlaygroundProvider provider) {
    return SimpleEmailField(
      controller: provider.account,
      label: 'Email or mobile number',
      suggestLabel: 'Did you mean ',
      focusNode: provider.focusEmail,
    );
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
                signInField(context, provider),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
