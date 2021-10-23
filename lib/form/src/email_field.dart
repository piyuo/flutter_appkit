import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:libcli/validator/validator.dart' as validator;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'field.dart';

/// ClickFieldProvider control place field
class EmailFieldProvider extends ChangeNotifier {
  EmailFieldProvider(this.focusNode, this.textController) {
    focusNode.addListener(onFocusChange);
  }

  @override
  void dispose() {
    focusNode.removeListener(onFocusChange);
    super.dispose();
  }

  /// _suggest is email address suggestion
  String _suggest = '';

  /// focusNode must be set on email field
  final FocusNode focusNode;

  /// controller control input value
  final TextEditingController textController;

  onFocusChange() {
    if (!focusNode.hasFocus) {
      _makeSuggestion();
    }
  }

  void _makeSuggestion() {
    _suggest = '';
    if (textController.text.isNotEmpty) {
      var suggest = validator.MailChecker(email: textController.text).suggest();
      if (suggest != null) {
        _suggest = suggest.full;
      }
    }
    notifyListeners();
  }

  _correctFromSuggestion() {
    textController.text = _suggest;
    _suggest = '';
    notifyListeners();
  }

  void setSuggest(String suggest) {
    _suggest = suggest;
    notifyListeners();
  }
}

/// EmailField is for email address input
class EmailField extends Field {
  /// controller is input value controller
  final TextEditingController controller;

  /// textInputAction control keyboard text input action
  final TextInputAction textInputAction;

  const EmailField({
    required Key key,
    required this.controller,
    required FocusNode focusNode,
    this.textInputAction = TextInputAction.next,
    String? label,
    String? hint,
    String? require,
    FormFieldValidator<String>? validator,
  }) : super(
          key: key,
          label: label,
          hint: hint,
          require: require,
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmailFieldProvider>(
      create: (context) => EmailFieldProvider(focusNode!, controller),
      child: Consumer<EmailFieldProvider>(builder: (context, pEmailField, child) {
        return Column(
          children: <Widget>[
            TextFormField(
              controller: controller,
              focusNode: focusNode,
              inputFormatters: [
                LengthLimitingTextInputFormatter(64),
              ],
              keyboardType: TextInputType.emailAddress,
              validator: (text) => validator.emailValidator(text),
              textInputAction: textInputAction,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                errorMaxLines: 2,
                hintText: label,
                labelText: label,
              ),
            ),
            pEmailField._suggest.isEmpty
                ? const SizedBox()
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
                          text: pEmailField._suggest,
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()..onTap = pEmailField._correctFromSuggestion,
                        )
                      ],
                    )),
                  ),
          ],
        );
      }),
    );
  }
}
