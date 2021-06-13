import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;

/// FormCheckbox is checkbox on form, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class Check extends StatefulWidget {
  final types.BoolController controller;

  final String label;

  final double width;

  final TextStyle? textStyle;

  Check({
    required this.controller,
    this.label = '',
    this.width = 24,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  CheckState createState() => CheckState();
}

class CheckState extends State<Check> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          setState(() {
            widget.controller.value = !widget.controller.value;
          });
        },
        child: Row(children: [
          RoundCheckbox(
            width: widget.width,
            value: widget.controller.value,
            onChanged: (bool? newValue) {
              setState(() {
                widget.controller.value = newValue ?? false;
              });
            },
          ),
          SizedBox(width: 8),
          Text(
            widget.label,
            style: widget.textStyle ?? Theme.of(context).textTheme.bodyText1,
          ),
        ]));
  }
}

class RoundCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double width;

  RoundCheckbox({
    Key? key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.width = 18,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: SizedBox(
        width: width,
        height: width,
        child: Container(
          decoration: new BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).unselectedWidgetColor), //?? Theme.of(context).disabledColor
            borderRadius: new BorderRadius.circular(6),
          ),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Transform.scale(
              scale: width / Checkbox.width,
              child: Checkbox(
                value: value,
                tristate: tristate,
                onChanged: this.onChanged,
                fillColor: Theme.of(context).checkboxTheme.fillColor,
                materialTapTargetSize: materialTapTargetSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
