import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'value_notifier_provider.dart';

/// Check is checkbox control, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class Check extends StatelessWidget {
  const Check({
    Key? key,
    required this.controller,
    this.label,
    this.size = 24,
    this.textStyle,
    this.checkColor,
    this.fillColor,
    this.disabled,
  }) : super(key: key);

  final ValueNotifier<bool> controller;

  final String? label;

  final double size;

  final TextStyle? textStyle;

  final Color? checkColor;

  final Color? fillColor;

  final bool? disabled;

  Widget _text(BuildContext context) {
    TextStyle style = disabled == true
        ? Theme.of(context).textTheme.bodyText1!.copyWith(color: Theme.of(context).disabledColor)
        : Theme.of(context).textTheme.bodyText1!;

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
    return ChangeNotifierProvider<ValueNotifierProvider>(
        create: (context) => ValueNotifierProvider(
              controller,
            ),
        child: Consumer<ValueNotifierProvider>(builder: (context, model, child) {
          return Row(children: [
            ClipRRect(
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
                        fillColor: disabled == true
                            ? MaterialStateProperty.all(Colors.grey)
                            : fillColor != null
                                ? MaterialStateProperty.all(fillColor)
                                : Theme.of(context).checkboxTheme.fillColor,
                        value: controller.value,
                        tristate: false,
                        onChanged: disabled == true ? null : (value) => model.setValue(context, value),
                        //            materialTapTargetSize: materialTapTargetSize,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            label != null
                ? disabled == true
                    ? _text(context)
                    : InkWell(onTap: () => model.setValue(context, controller.value), child: _text(context))
                : const SizedBox(),
          ]);
        }));
  }
}
