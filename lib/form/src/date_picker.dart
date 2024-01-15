import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'date_value_accessor.dart';

/// [DatePicker] is a date picker can pick single date
class DatePicker extends ReactiveDatePicker<DateTime> {
  DatePicker({
    super.formControlName,
    super.formControl,
    InputDecoration? decoration,
    TextStyle? style,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    required super.firstDate,
    required super.lastDate,
    DateTime? currentDate,
    RouteSettings? routeSettings,
    Map<String, String Function(Object)>? validationMessages,
    Widget? Function(
            {required DateTime date,
            BoxDecoration? decoration,
            bool? isDisabled,
            bool? isSelected,
            bool? isToday,
            TextStyle? textStyle})?
        dayBuilder,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    super.key,
  }) : super(
          builder: (context, picker, child) {
            return ReactiveTextField<DateTime>(
              valueAccessor: DateDisplayValueAccessor(),
              formControlName: formControlName,
              decoration: decoration ?? const InputDecoration(),
              onTap: (FormControl control) => picker.showPicker(),
              mouseCursor: SystemMouseCursors.click,
              style: style,
              textAlign: textAlign,
              textDirection: textDirection,
              textCapitalization: textCapitalization,
              autofocus: false,
              readOnly: true,
              inputFormatters: inputFormatters,
              validationMessages: validationMessages,
            );
          },
        );
}
