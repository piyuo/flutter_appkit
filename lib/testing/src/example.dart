import 'package:flutter/material.dart';

Widget _button(BuildContext context, String text, void Function() callback) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: ElevatedButton(child: Text(text), onPressed: callback),
  );
}

void _show(BuildContext context, Widget child) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(),
          body: SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ))),
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
  return _button(context, text!, () => _show(context, child!));
}
