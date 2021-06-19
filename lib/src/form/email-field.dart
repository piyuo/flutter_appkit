import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:libcli/validator.dart' as validator;
import 'package:libcli/i18n.dart' as i18n;
import 'field.dart';

class EmailField extends Field {
  /// controller is input value controller
  final TextEditingController controller;

  /// textInputAction control keyboard text input action
  final TextInputAction textInputAction;

  EmailField({
    required this.controller,
    this.textInputAction = TextInputAction.next,
    String? label,
    String? hint,
    String? required,
    FormFieldValidator<String>? validator,
    FocusNode? focusNode,
    Key? key,
  }) : super(
          key: key,
          label: label,
          hint: hint,
          required: required,
          validator: validator,
          focusNode: focusNode,
        );

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  String? defaultValidator(String? text) {
    var result = super.defaultValidator(text);
    if (result != null) {
      return result;
    }
    if (text!.length > 96) {
      return 'maxLength'.i18n_.replaceAll('%1', label ?? '').replaceAll('%2', '96').replaceAll('%3', '${text.length}');
    }
    return null;
  }

  @override
  EmailFieldState createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  /// _suggest is email address suggestion
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
                      text: 'youMean'.i18n_,
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
