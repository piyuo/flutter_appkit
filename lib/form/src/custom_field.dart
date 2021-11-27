import 'package:flutter/material.dart';

class CustomField<T> extends StatefulWidget {
  const CustomField({
    required this.controller,
    required this.label,
    required this.builder,
    this.border,
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

  /// border for input border
  ///
  ///  * [InputBorder.none], which doesn't draw a border.
  ///  * [UnderlineInputBorder], which draws a horizontal line at the
  ///    bottom of the input decorator's container.
  ///  * [OutlineInputBorder], an [InputDecorator] border which draws a
  ///    rounded rectangle around the input decorator's container.
  final InputBorder? border;

  final String? Function(T?)? validator;

  /// suffixIcon is suffix icon
  final Widget? suffixIcon;

  /// builder to build display widget
  final Widget Function() builder;

  String? validate() => validator?.call(controller.value);

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
        border: widget.border,
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
        builder: (FormFieldState<T> state) => widget.builder(),
      ),
    );
  }
}
