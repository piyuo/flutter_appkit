import 'package:flutter/material.dart';

class CustomField<T> extends StatefulWidget {
  const CustomField({
    required this.controller,
    required this.valueToString,
    required this.label,
    this.onTap,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.suffixIcon,
    Key? key,
  }) : super(key: key);

  /// controller is dropdown value controller
  final ValueNotifier<T?> controller;

  final FocusNode? focusNode;

  final FocusNode? nextFocusNode;

  /// label will show when value is not empty
  final String? label;

  final VoidCallback? onTap;

  final String? Function(T?)? validator;

  /// valueString show string to represent value
  final String Function(T?) valueToString;

  /// suffixIcon is suffix icon
  final Widget? suffixIcon;

  String get valueText => valueToString(controller.value);

  String? validate() {
    return validator?.call(controller.value);
  }

  @override
  State<StatefulWidget> createState() => _CustomFieldState<T>();
}

class _CustomFieldState<T> extends State<CustomField> {
  String? _error;

  @override
  void initState() {
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(_onFocusChanged);
    }
    widget.controller.addListener(_onValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.focusNode != null) {
      widget.focusNode!.removeListener(_onFocusChanged);
    }
    widget.controller.removeListener(_onValueChanged);
    super.dispose();
  }

  /// _onValueChanged happen when control value change
  void _onValueChanged() {
    setState(() {
      _error = null;
    });
  }

  /// _onFocusChanged happen when control focus change
  void _onFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      isFocused: widget.focusNode != null ? widget.focusNode!.hasFocus : false,
      isEmpty: widget.controller.value == null,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: _error,
        suffixIcon: widget.suffixIcon,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
      child: FormField<T>(
        key: widget.key,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (T? value) {
          setState(() {
            _error = widget.validate();
          });
          return _error;
        },
        builder: (FormFieldState<T> state) {
          return InkWell(
            focusNode: widget.focusNode,
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
              child: Text(widget.valueText, style: Theme.of(context).textTheme.subtitle1),
            ),
          );
        },
      ),
    );
  }
}
