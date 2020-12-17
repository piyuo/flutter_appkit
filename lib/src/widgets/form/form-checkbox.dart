import 'package:flutter/material.dart';
import 'package:libcli/src/widgets/controller/bool-editing-controller.dart';

/// FormCheckbox is checkbox on form, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class FormCheckbox extends StatefulWidget {
  final BoolEditingController controller;

  final Widget? child;

  final String? label;

  final String? link;

  final Function()? onLinkClicked;

  FormCheckbox({
    required this.controller,
    this.label,
    this.link,
    this.onLinkClicked,
    this.child,
    Key? key,
  }) : super(key: key);

  @override
  FormCheckboxState createState() => FormCheckboxState();
}

class FormCheckboxState extends State<FormCheckbox> {
  Widget createLabel() {
    return Row(
      children: [
        Text(widget.label!,
            style: TextStyle(
              color: Color.fromRGBO(134, 134, 139, 1),
            )),
        SizedBox(width: 10),
        widget.link != null
            ? InkWell(
                child: Text(widget.link!,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 102, 204, 1),
                    )),
                onTap: () {
                  if (widget.onLinkClicked != null) {
                    widget.onLinkClicked!();
                  }
                },
              )
            : SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: widget.child != null
          ? widget.child!
          : widget.label != null
              ? createLabel()
              : null,
      value: widget.controller.value,
      onChanged: (bool? newValue) {
        setState(() {
          widget.controller.value = newValue ?? false;
        });
      },
    );
  }
}
