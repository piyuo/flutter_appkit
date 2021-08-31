import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Check is checkbox control, do not use HyperText or RichText as it's child. it will conflict
/// https://api.flutter.dev/flutter/material/CheckboxListTile-class.html
///
class Check extends StatelessWidget {
  Check({
    required this.controller,
    this.label,
    this.size = 24,
    this.textStyle,
    this.checkColor,
    this.fillColor,
    this.disabled,
  });

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
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Text(
        label!,
        style: textStyle ?? style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckProvider>(
        create: (context) => CheckProvider(
              controller: controller,
            ),
        child: Consumer<CheckProvider>(builder: (context, model, child) {
          return Row(children: [
            ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: SizedBox(
                width: 24,
                height: 24,
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
                      scale: 24 / Checkbox.width,
                      child: Checkbox(
                        checkColor: checkColor != null ? checkColor : null,
                        fillColor: disabled == true
                            ? MaterialStateProperty.all(Colors.grey)
                            : fillColor != null
                                ? MaterialStateProperty.all(fillColor)
                                : Theme.of(context).checkboxTheme.fillColor,
                        value: controller.value,
                        tristate: false,
                        onChanged: disabled == true ? null : model.setValue,
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
                    : InkWell(onTap: () => model.setValue(!controller.value), child: _text(context))
                : SizedBox(),
          ]);
        }));
  }
}

class CheckProvider with ChangeNotifier {
  CheckProvider({
    required this.controller,
  });

  /// controller control checkbox value
  final ValueNotifier<bool> controller;

  void setValue(bool? newValue) {
    controller.value = newValue ?? false;
    notifyListeners();
  }
}
