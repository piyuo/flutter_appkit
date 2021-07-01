//import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialog.dart' as dialog;

/// SubmitProvider provide submit state
class SubmitProvider extends ChangeNotifier {
  bool _pressed = false;

  void setPressed(bool pressed) {
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
  final String text;

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

  Submit(
    this.text, {
    required this.onClick,
    this.focusNode,
    this.form,
    this.sizeLevel = 1,
    this.showLoading = const Duration(seconds: 1),
  });

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
          child: Text(text, style: TextStyle(fontSize: 18 * sizeLevel, fontWeight: FontWeight.bold)),
          onPressed: () async {
            if (pSubmit._pressed) {
              return;
            }

            if (form != null && !form!.currentState!.validate()) {
              return;
            }

            dialog.loading(context);
            pSubmit.setPressed(true);
            try {
              await onClick();
            } finally {
              pSubmit.setPressed(false);
              dialog.dismiss();
            }
          },
        );
      }),
    );
  }
}
