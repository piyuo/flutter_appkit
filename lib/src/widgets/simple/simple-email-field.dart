import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:libcli/validator.dart' as validator;

class SimpleEmailField extends StatefulWidget {
  final TextEditingController controller;

  final String label;

  final String suggestLabel;

  final FocusNode? focusNode;

  final FocusNode? nextFocusNode;

  final TextInputAction textInputAction;

  SimpleEmailField({
    required this.controller,
    required this.label,
    required this.suggestLabel,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.next,
    Key? key,
  }) : super(key: key);

  @override
  SimpleEmailFieldState createState() => SimpleEmailFieldState();
}

class SimpleEmailFieldState extends State<SimpleEmailField> {
  String _suggest = '';

  onFocusChange() {
    if (widget.focusNode != null && !widget.focusNode!.hasFocus) {
      _makeSuggestion();
    }
  }

  void _makeSuggestion() {
    setState(() {
      _suggest = '';
      if (!widget.controller.text.isEmpty) {
        var suggest = validator.MailChecker(email: widget.controller.text).suggest();
        if (suggest != null) {
          _suggest = suggest.full;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(onFocusChange);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(onFocusChange);
    }
  }

  _correctFromSuggestion() {
    setState(() {
      widget.controller.text = _suggest;
      _suggest = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          inputFormatters: [
            LengthLimitingTextInputFormatter(64),
          ],
          keyboardType: TextInputType.emailAddress,
          validator: (text) => validator.emailValidator(text),
          textInputAction: widget.textInputAction,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            errorMaxLines: 2,
            hintText: widget.label,
            labelText: widget.label,
          ),
        ),
        _suggest.isEmpty
            ? SizedBox()
            : Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                    text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.suggestLabel,
                      style: TextStyle(
                        color: Colors.yellow[900],
                      ),
                    ),
                    TextSpan(
                      text: _suggest,
                      style: TextStyle(color: Colors.blue),
                      recognizer: new TapGestureRecognizer()..onTap = _correctFromSuggestion,
                    )
                  ],
                )),
              ),
      ],
    );
  }
}
