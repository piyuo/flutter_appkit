import 'package:flutter/material.dart';
import 'package:libcli/delta.dart' as delta;

Widget button(BuildContext context, String text, void Function() callback) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: ElevatedButton(child: Text(text), onPressed: callback),
  );
}

void show(BuildContext context, Widget child) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: delta.Bar(),
          body: child,
        ),
      ));
}

Widget example(
  BuildContext context, {
  String? text,
  Widget? child,
}) {
  assert(text != null);
  assert(child != null);
  return button(context, text!, () => show(context, child!));
}
