//import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/dialog/dialog.dart' as dialog;

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
  const Submit({
    required Key key, // all submit must have key, it's important for test and identify field
    required this.label,
    required this.onClick,
    this.focusNode,
    this.form,
    this.width = 240,
    this.fontSize = 18,
    this.padding = const EdgeInsets.all(16),
    this.showLoading = const Duration(seconds: 1),
  }) : super(key: key);

  /// width is button fixed width
  ///
  final double? width;

  /// padding is button padding
  ///
  final EdgeInsets padding;

  /// fontSize is button font size
  ///
  final double fontSize;

  /// text is button text
  ///
  final String label;

  /// onClick called when onClickStart() return true, return true if click are success
  ///
  final Future<void> Function() onClick;

  /// focusNode is focusNode set to button
  ///
  final FocusNode? focusNode;

  /// form is form key, button will call form.validate() if form is not null
  ///
  final GlobalKey<FormState>? form;

  /// showLoading is not null will show loading toast after duration
  ///
  final Duration? showLoading;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SubmitProvider>(
      create: (context) => SubmitProvider(),
      child: Consumer<SubmitProvider>(builder: (context, provide, child) {
        return ElevatedButton(
          focusNode: focusNode,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(provide._pressed ? Theme.of(context).disabledColor : null),
            elevation: MaterialStateProperty.all(provide._pressed ? 1 : 6),
            fixedSize: width != null ? MaterialStateProperty.all(Size(width!, 42)) : null,
            padding: MaterialStateProperty.all(padding),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            )),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (provide._pressed) {
              return;
            }

            if (form != null && !form!.currentState!.validate()) {
              return;
            }

            dialog.toastLoading(context);
            provide._setPressed(true);
            try {
              await onClick();
            } finally {
              provide._setPressed(false);
              dialog.dismiss();
            }
          },
        );
      }),
    );
  }
}
