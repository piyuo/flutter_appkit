import 'package:flutter/material.dart';
import 'field.dart';

typedef ClickFiledCallback = Future<String> Function(String text);

/// ClickFiled show read only text, user must click to change value
class ClickField extends Field {
  ClickField({
    required this.controller,
    required this.onClicked,
    String? label,
    String? required,
    FocusNode? focusNode,
    Key? key,
  }) : super(
          key: key,
          label: label,
          required: required,
          focusNode: focusNode,
        );

  /// controller is dropdown value controller
  final TextEditingController controller;

  /// onClicked must return new string result
  final ClickFiledCallback onClicked;

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  ClickFieldState createState() => ClickFieldState();
}

class ClickFieldState extends State<ClickField> {
  String? _error = null;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final text = await widget.onClicked(widget.controller.text);
        final result = widget.defaultValidator(text);
        setState(() {
          _error = result;
          widget.controller.text = text;
        });
      },
      child: InputDecorator(
        isEmpty: widget.controller.text.isEmpty,
        decoration: InputDecoration(
          labelText: widget.label,
          errorText: _error,
          suffixIcon: Icon(
            Icons.arrow_forward_ios,
          ),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        child: ClickFormField(
          validator: (String? text) {
            final result = widget.defaultValidator(widget.controller.text);
            setState(() => _error = result);
            return result;
          },
          controller: widget.controller,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
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
