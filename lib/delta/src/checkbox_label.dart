import 'package:flutter/material.dart';
import 'round_checkbox.dart';

/// CheckboxLabel is checkbox control with label, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class CheckboxLabel extends StatelessWidget {
  const CheckboxLabel({
    required this.checked,
    this.onChanged,
    this.label,
    this.size = 24,
    this.textStyle,
    this.checkColor,
    this.fillColor,
    super.key,
  });

  final bool checked;

  final Function(bool)? onChanged;

  final String? label;

  final double size;

  final TextStyle? textStyle;

  final Color? checkColor;

  final Color? fillColor;

  Widget _text(BuildContext context) {
    TextStyle style = onChanged == null
        ? Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).disabledColor)
        : Theme.of(context).textTheme.bodyLarge!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Text(
        label!,
        style: textStyle ?? style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      RoundCheckbox(
        checked: checked,
        onChanged: onChanged,
        size: size,
        checkColor: checkColor,
        fillColor: fillColor,
      ),
      label != null
          ? onChanged == null
              ? _text(context)
              : InkWell(
                  onTap: onChanged == null ? null : () => onChanged!(!checked),
                  child: _text(context),
                )
          : const SizedBox(),
    ]);
  }
}
