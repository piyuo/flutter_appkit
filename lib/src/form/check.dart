import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;

/// Check is checkbox on form, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class Check extends StatelessWidget {
  Check({
    required this.controller,
    this.label = '',
    this.width = 24,
    this.textStyle,
  });

  final types.BoolController controller;

  final String label;

  final double width;

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return types.requireRedraw(
      builder: (context, pRedraw, child) {
        return InkWell(
            onTap: () {
              controller.value = !controller.value;
              pRedraw.redraw();
            },
            child: Row(children: [
              RoundCheckbox(
                width: width,
                value: controller.value,
                onChanged: (bool? newValue) {
                  controller.value = newValue!;
                  pRedraw.redraw();
                },
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: textStyle ?? Theme.of(context).textTheme.bodyText1,
              ),
            ]));
      },
    );
  }
}

/// RoundCheckbox create a round checkbox
class RoundCheckbox extends StatelessWidget {
  RoundCheckbox({
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.width = 18,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final double width;

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
                onChanged: onChanged,
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
