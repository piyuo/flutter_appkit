import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'date_picker2.dart';
import 'date_value_accessor.dart';

/// DatePicker2Range is a date picker using calendar_date_picker2 package
class DatePicker2Range extends ReactiveFormField<DateTimeRange?, String> {
  DatePicker2Range({
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
          valueAccessor: DateRangeValueAccessor(),
          builder: (field) {
            return ReactiveTextField<DateTimeRange?>(
              formControlName: formControlName,
              decoration: decoration ?? const InputDecoration(),
              valueAccessor: DateRangeDisplayValueAccessor(),
              onTap: (FormControl control) async {
                final dateRange = await showCalendarDatePicker2Dialog(
                  context: field.context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.range,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    currentDate: currentDate,
                    dayBuilder: dayBuilder,
                  ),
                  value: field.control.value == null ? [] : [field.control.value!.start, field.control.value!.end],
                  dialogSize: kDatePicker2DefaultSize,
                  useRootNavigator: useRootNavigator,
                  routeSettings: routeSettings,
                  builder: builder,
                );

                if (dateRange == null) {
                  return;
                }
                if (dateRange.length == 1) {
                  dateRange.add(dateRange[0]!.add(const Duration(days: 1)));
                }
                field.control.markAsTouched();
                final effectiveValueAccessor = DateRangeValueAccessor();
                field.didChange(dateRange.isEmpty
                    ? null
                    : effectiveValueAccessor.modelToViewValue(
                        DateTimeRange(start: dateRange[0]!, end: dateRange[1]!),
                      ));
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
