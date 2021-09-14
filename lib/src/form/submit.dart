//import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialog.dart' as dialog;

/// SubmitProvider provide submit state
class SubmitProvider extends ChangeNotifier {
  /// _pressed is true when button is pressed
  bool _pressed = false;

  /// _setPressed set button pressed
  void _setPressed(bool pressed) {
    _pressed = pressed;
    notifyListeners();
  }
}

class Submit extends StatelessWidget {
  /// sizeLevel is button size level, default is 1
  ///
  final double sizeLevel;

  /// text is button text
  ///
  final String label;

  /// onClick called when onClickStart() return true, return true if click are success
  ///
  final Function() onClick;

  /// focusNode is focusNode set to button
  ///
  final FocusNode? focusNode;

  /// form is form key, button will call form.validate() if form is not null
  ///
  final GlobalKey<FormState>? form;

  /// showLoading is not null will show loading toast after duration
  ///
  final Duration? showLoading;

  const Submit({
    required Key key, // all submit must have key, it's important for test and identify field
    required this.label,
    required this.onClick,
    this.focusNode,
    this.form,
    this.sizeLevel = 1,
    this.showLoading = const Duration(seconds: 1),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SubmitProvider>(
      create: (context) => SubmitProvider(),
      child: Consumer<SubmitProvider>(builder: (context, pSubmit, child) {
        return ElevatedButton(
          focusNode: focusNode,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(pSubmit._pressed ? Theme.of(context).disabledColor : null),
            elevation: MaterialStateProperty.all(pSubmit._pressed ? 1 : 6),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              vertical: 16 * sizeLevel,
              horizontal: 34 * sizeLevel,
            )),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28 * sizeLevel),
            )),
          ),
          child: Text(label, style: TextStyle(fontSize: 18 * sizeLevel, fontWeight: FontWeight.bold)),
          onPressed: () async {
            if (pSubmit._pressed) {
              return;
            }

            if (form != null && !form!.currentState!.validate()) {
              return;
            }

            dialog.loading(context);
            pSubmit._setPressed(true);
            try {
              await onClick();
            } finally {
              pSubmit._setPressed(false);
              dialog.dismiss();
            }
          },
        );
      }),
    );
  }
}
