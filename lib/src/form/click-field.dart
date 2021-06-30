import 'package:flutter/material.dart';
import 'field.dart';
import 'package:provider/provider.dart';

typedef ClickFiledCallback = Future<String> Function(String text);

/// ClickFieldProvider control place field
class ClickFieldProvider extends ChangeNotifier {
  String? _error = null;

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setFocus(bool hasFocus) {
    notifyListeners();
  }
}

/// ClickFiled show read only text, user must click to change value
class ClickField extends Field {
  ClickField({
    required this.controller,
    required this.onClicked,
    String? label,
    String? require,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    Key? key,
  }) : super(
          key: key,
          label: label,
          require: require,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        ) {}

  /// controller is dropdown value controller
  final TextEditingController controller;

  /// onClicked must return new string result
  final ClickFiledCallback onClicked;

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    final _onClick = (ClickFieldProvider provider) async {
      final text = await onClicked(controller.text);
      final result = defaultValidator(text);
      provider._setError(result);
      controller.text = text;
      if (result == null && nextFocusNode != null) {
        nextFocusNode!.requestFocus();
      }
    };

    return ChangeNotifierProvider<ClickFieldProvider>(
      create: (context) => ClickFieldProvider(),
      child: Consumer<ClickFieldProvider>(builder: (context, pClickField, child) {
        return Focus(
          focusNode: focusNode,
          child: InkWell(
            onTap: () => _onClick(pClickField),
            child: InputDecorator(
              isFocused: focusNode != null ? focusNode!.hasFocus : false,
              isEmpty: controller.text.isEmpty,
              decoration: InputDecoration(
                labelText: label,
                hintText: 'my hint',
                errorText: pClickField._error,
                suffixIcon: Icon(
                  Icons.arrow_forward_ios,
                ),
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
              child: ClickFormField(
                validator: (String? text) {
                  final result = defaultValidator(controller.text);
                  pClickField._setError(result);
                  return result;
                },
                controller: controller,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _onClick(pClickField);
            }
            pClickField._setFocus(hasFocus);
          },
        );
      }),
    );
  }
}

/// ClickFormField to handle validator event
class ClickFormField extends FormField<String> {
  ClickFormField({
    required FormFieldValidator<String> validator,
    required TextEditingController controller,
    TextStyle? style,
  }) : super(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Text(controller.text, style: style);
          },
        );
}
