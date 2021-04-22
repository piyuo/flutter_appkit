import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/controller/bool-editing-controller.dart';

/// FormCheckbox is checkbox on form, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class FormCheckbox extends StatefulWidget {
  final BoolEditingController controller;

  final Widget? child;

  final String? label;

  final double size;

  FormCheckbox({
    required this.controller,
    this.label,
    this.child,
    this.size = 24,
    Key? key,
  }) : super(key: key);

  @override
  FormCheckboxState createState() => FormCheckboxState();
}

class FormCheckboxState extends State<FormCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: widget.size / Checkbox.width,
        child: CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.all(0),
          title: widget.child != null
              ? widget.child!
              : widget.label != null
                  ? Text(widget.label!, style: Theme.of(context).primaryTextTheme.bodyText1)
                  : null,
          value: widget.controller.value,
          onChanged: (bool? newValue) {
            setState(() {
              widget.controller.value = newValue ?? false;
            });
          },
        ));
  }
}
