import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'date_value_accessor.dart';

/// kDatePicker2DefaultSize is the default dialog size of the date picker
const kDatePicker2DefaultSize = Size(325, 400);

/// DatePicker2 is a date picker using calendar_date_picker2 package
class DatePicker2 extends ReactiveFormField<DateTime?, String> {
  DatePicker2({
    super.formControlName,
    super.formControl,
    super.validationMessages,
    InputDecoration? decoration,
    TextStyle? style,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    RouteSettings? routeSettings,
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
          valueAccessor: DateValueAccessor(),
          builder: (field) {
            return ReactiveTextField<DateTime>(
              valueAccessor: DateDisplayValueAccessor(),
              formControlName: formControlName,
              decoration: decoration ?? const InputDecoration(),
              onTap: (FormControl control) async {
                final date = await showCalendarDatePicker2Dialog(
                  context: field.context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.single,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    currentDate: currentDate,
                    dayBuilder: dayBuilder,
                  ),
                  value: [field.control.value],
                  dialogSize: kDatePicker2DefaultSize,
                  useRootNavigator: useRootNavigator,
                  routeSettings: routeSettings,
                  builder: builder,
                );

                if (date == null) {
                  return;
                }
                field.control.markAsTouched();
                final effectiveValueAccessor = DateValueAccessor();
                field.didChange(date.isEmpty ? null : effectiveValueAccessor.modelToViewValue(date[0]));
              },
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
