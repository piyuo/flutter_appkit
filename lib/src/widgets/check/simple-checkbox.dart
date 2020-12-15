import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/bool-editing-controller.dart';

class SimpleCheckbox extends StatefulWidget {
  final BoolEditingController controller;

  final Widget? child;

  final String? label;

  SimpleCheckbox({
    required this.controller,
    this.label,
    this.child,
    Key? key,
  })  : assert(label != null || child != null, 'must have label or child'),
        super(key: key);

  @override
  SimpleCheckboxState createState() => SimpleCheckboxState();
}

class SimpleCheckboxState extends State<SimpleCheckbox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: widget.child != null
          ? widget.child!
          : Text(
              widget.label!,
              style: TextStyle(
                  //fontWeight: FontWeight.w600,
                  color: Colors.grey[850],
                  fontSize: 14.0),
            ),
      value: widget.controller.value,
      onChanged: (bool? newValue) {
        setState(() {
          widget.controller.value = newValue ?? false;
        });
      },
    );
  }
}
