import 'package:flutter/material.dart';

/// RoundCheckbox is checkbox control with round border
///
class RoundCheckbox extends StatelessWidget {
  const RoundCheckbox({
    required this.checked,
    this.onChanged,
    this.size = 24,
    this.checkColor,
    this.fillColor,
    super.key,
  });

  final bool checked;

  final Function(bool)? onChanged;

  final double size;

  final Color? checkColor;

  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: SizedBox(
        width: 24,
        height: 24,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).unselectedWidgetColor), //?? Theme.of(context).disabledColor
            borderRadius: BorderRadius.circular(6),
          ),
          child: Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.transparent,
            ),
            child: Transform.scale(
              scale: 24 / Checkbox.width,
              child: Checkbox(
                checkColor: checkColor,
                fillColor: onChanged == null
                    ? MaterialStateProperty.all(Colors.grey)
                    : fillColor != null
                        ? MaterialStateProperty.all(fillColor)
                        : Theme.of(context).checkboxTheme.fillColor,
                value: checked,
                tristate: false,
                onChanged: onChanged == null ? null : (v) => onChanged!(v == true),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
