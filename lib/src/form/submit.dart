//import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/dialog.dart' as dialog;

class Submit extends StatefulWidget {
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
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SubmitState();
}

class SubmitState extends State<Submit> {
  bool _pressed = false;

/*
  Timer? _timer;
  void startTimer() {
    if (_timer == null && widget.showLoading != null) {
      dialog.loading(context);
      _timer = Timer(widget.showLoading!, () {
        if (_pressed) {}
      });
    }
  }
  void stopTimer() {
    if (_timer != null) {
      dialog.dismiss();
      _timer!.cancel();
      _timer = null;
    }
  }
  @override
  @mustCallSuper
  void dispose() {
    stopTimer();
    super.dispose();
  }
*/

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      focusNode: widget.focusNode,
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(_pressed ? Theme.of(context).disabledColor : Theme.of(context).primaryColor),
        padding: MaterialStateProperty.all(EdgeInsets.fromLTRB(
            36 * widget.sizeLevel, 26 * widget.sizeLevel, 36 * widget.sizeLevel, 26 * widget.sizeLevel)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(34 * widget.sizeLevel),
        )),
      ),
      child: Text(widget.text, style: TextStyle(fontSize: 18 * widget.sizeLevel, fontWeight: FontWeight.bold)),
      onPressed: () async {
        if (_pressed) {
          return;
        }

        if (widget.form != null && !widget.form!.currentState!.validate()) {
          return;
        }

        dialog.loading(context);
        setState(() => _pressed = true);
        try {
          await widget.onClick();
        } finally {
          setState(() => _pressed = false);
          dialog.dismiss();
        }
      },
    );
  }
}
