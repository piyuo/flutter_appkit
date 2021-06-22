import 'package:flutter/material.dart';
import 'field.dart';

typedef ClickFiledCallback = Future<String> Function(String text);

class ClickField extends Field {
  /// controller is dropdown value controller
  final TextEditingController controller;

  final ClickFiledCallback onClicked;

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

  @override
  bool isEmpty() => controller.text.isEmpty;

  @override
  ClickFieldState createState() => ClickFieldState();
}

class ClickFieldState extends State<ClickField> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final text = await widget.onClicked(widget.controller.text);
        setState(() => widget.controller.text = text);
      },
      child: InputDecorator(
        isEmpty: widget.controller.text.isEmpty,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: Icon(
            Icons.arrow_forward_ios,
          ),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        child: Text(widget.controller.text, style: Theme.of(context).textTheme.bodyText1),
      ),
    );
  }
}
