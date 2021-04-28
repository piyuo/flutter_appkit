//import 'package:flutter/gestures.dart';
//import 'package:libcli/dialog.dart' as dialog;
//import 'package:libcli/widgets.dart' as widgets;

bool useMobileLayout(double width) {
  return width < 600 ? true : false;
}

/*
emailField(BuildContext context, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.emailAddress,
    validator: (text) => validator.emailValidator(text),
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]"))],
    textInputAction: TextInputAction.next,
    onFieldSubmitted: (text) {
      print('submit $text');
    },
    decoration: InputDecoration(
      hintText: 'Email address',
      labelText: 'Email address',
    ),
  );
}
*/
