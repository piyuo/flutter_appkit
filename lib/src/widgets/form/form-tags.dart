import 'package:flutter/material.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:libcli/src/validator/validator.dart' as validator;
//import 'package:libcli/dialog.dart' as dialog;
//import 'package:libcli/widgets.dart' as widgets;

bool useMobileLayout(double width) {
  return width < 600 ? true : false;
}

Widget h1(String text, {Color? color}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w800,
      color: color ?? Colors.black,
      fontSize: 24.0,
    ),
  );
}

Widget h2(String text, {Color? color}) {
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      color: color ?? Colors.grey[400],
      fontSize: 18.0,
    ),
  );
}

Widget h3(String text, {Color? color}) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Text(
        text,
        style: TextStyle(
            //fontWeight: FontWeight.w600,
            color: color ?? Colors.grey[850],
            fontSize: 14.0),
      ));
}

Widget p() {
  return SizedBox(
    height: 48,
  );
}

Widget br() {
  return SizedBox(
    height: 24,
  );
}

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
