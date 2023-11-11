import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'checkbox_label.dart';

/// Check is checkbox control, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class Check extends StatelessWidget {
  const Check({
    super.key,
    this.controller,
    this.label,
    this.size = 24,
    this.textStyle,
    this.checkColor,
    this.fillColor,
    this.disabled,
  });

  /// controller is null will disable control
  final ValueNotifier<bool>? controller;

  final String? label;

  final double size;

  final TextStyle? textStyle;

  final Color? checkColor;

  final Color? fillColor;

  final bool? disabled;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        child: Consumer<ValueNotifier<bool>?>(builder: (context, _, __) {
          return CheckboxLabel(
            checked: controller == null ? false : controller!.value,
            onChanged: controller == null ? null : (value) => controller!.value = value,
            label: label,
            size: size,
            textStyle: textStyle,
            checkColor: checkColor,
            fillColor: fillColor,
          );
        }));
  }
}
