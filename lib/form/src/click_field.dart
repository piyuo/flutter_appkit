import 'package:flutter/material.dart';
import 'field.dart';
import 'package:provider/provider.dart';

typedef ClickFiledCallback = Future<String> Function(String text);

/// ClickFieldProvider control place field
class ClickFieldProvider extends ChangeNotifier {
  String? _error;

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
  const ClickField({
    required Key key,
    required this.controller,
    required this.onClicked,
    String? label,
    String? hint,
    String? require,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          key: key,
          label: label,
          hint: hint,
          require: require,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  /// controller is dropdown value controller
  final TextEditingController controller;

  /// onClicked must return new string result
  final ClickFiledCallback onClicked;

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClickFieldProvider>(
      create: (context) => ClickFieldProvider(),
      child: Consumer<ClickFieldProvider>(builder: (context, pClickField, child) {
        return Focus(
          focusNode: focusNode,
          child: InkWell(
            onTap: () async {
              final text = await onClicked(controller.text);
              final result = validate(text);
              pClickField._setError(result);
              controller.text = text;
              if (result == null && nextFocusNode != null) {
                nextFocusNode!.requestFocus();
              }
            },
            child: InputDecorator(
              isFocused: focusNode != null ? focusNode!.hasFocus : false,
              isEmpty: controller.text.isEmpty,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                errorText: pClickField._error,
                suffixIcon: const Icon(
                  Icons.navigate_next,
                ),
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
              child: ClickFormField(
                validator: (String? text) {
                  final result = validate(controller.text);
                  pClickField._setError(result);
                  return result;
                },
                controller: controller,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
          onFocusChange: (hasFocus) {
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
    Key? key,
    required FormFieldValidator<String> validator,
    required TextEditingController controller,
    TextStyle? style,
  }) : super(
          key: key,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Text(controller.text, style: style);
          },
        );
}
