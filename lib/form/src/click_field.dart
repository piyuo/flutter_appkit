import 'package:flutter/material.dart';
import 'field.dart';
import 'package:provider/provider.dart';

/// _ClickFieldProvider control place field
class _ClickFieldProvider extends ChangeNotifier {
  String? _error;

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _refresh() {
    notifyListeners();
  }
}

/// ClickFiled show read only text, user must click to change value
class ClickField<T> extends Field<T> {
  const ClickField({
    required Key key,
    required this.controller,
    required this.onClicked,
    required this.valueToString,
    FormFieldValidator<T>? validator,
    String? label,
    String? require,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
  }) : super(
          key: key,
          validator: validator,
          label: label,
          require: require,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        );

  /// controller is dropdown value controller
  final ValueNotifier controller;

  /// onClicked must return new string result
  final Future<T> Function(T? value) onClicked;

  /// valueToString convert value to string
  final String Function(T? value) valueToString;

  /// superValidate use field validate
  String? superValidate(T? value) => super.validate(value);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ClickFieldProvider>(
      create: (context) => _ClickFieldProvider(),
      child: Consumer<_ClickFieldProvider>(builder: (context, provide, child) {
        return Focus(
          focusNode: focusNode,
          child: InkWell(
            onTap: () async {
              controller.value = await onClicked(controller.value);
              provide._refresh();
              if (nextFocusNode != null) {
                nextFocusNode!.requestFocus();
              }
            },
            child: InputDecorator(
              isFocused: focusNode != null ? focusNode!.hasFocus : false,
              isEmpty: controller.value == null,
              decoration: InputDecoration(
                labelText: label,
                errorText: provide._error,
                suffixIcon: const Icon(
                  Icons.navigate_next,
                ),
              ).applyDefaults(Theme.of(context).inputDecorationTheme),
              child: FormField<T>(
                key: key,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (T? value) {
                  provide._setError(superValidate(value));
                },
                builder: (FormFieldState<T> state) {
                  return Text(valueToString(controller.value), style: Theme.of(context).textTheme.subtitle1);
                },
              ),
            ),
          ),
          onFocusChange: (hasFocus) {
            provide._refresh();
          },
        );
      }),
    );
  }
}
