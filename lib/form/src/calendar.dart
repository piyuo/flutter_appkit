import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

enum CalendarType { single, multi, range }

/// Calendar is a convenience widget that can pick single date or date range or multi date
class Calendar extends ReactiveFormField<List<DateTime?>, List<DateTime?>> {
  Calendar({
    CalendarType calendarType = CalendarType.single,
    String? formControlName,
    FormControl<List<DateTime?>>? formControl,
    Map<String, ValidationMessageFunction>? validationMessages,
    ShowErrorsFunction? showErrors,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    Widget? Function(
            {required DateTime date,
            BoxDecoration? decoration,
            bool? isDisabled,
            bool? isSelected,
            bool? isToday,
            TextStyle? textStyle})?
        dayBuilder,
    Key? key,
  }) : super(
          key: key,
          formControl: formControl,
          formControlName: formControlName,
          validationMessages: validationMessages,
          showErrors: showErrors,
          builder: (field) {
            return CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: calendarType == CalendarType.single
                    ? CalendarDatePicker2Type.single
                    : calendarType == CalendarType.multi
                        ? CalendarDatePicker2Type.multi
                        : CalendarDatePicker2Type.range,
                firstDate: firstDate,
                lastDate: lastDate,
                currentDate: currentDate,
                dayBuilder: dayBuilder,
              ),
              value: field.control.value ?? [],
              onValueChanged: (dates) {
                field.control.markAsTouched();
                field.didChange(dates);
              },
            );
          },
        );
}

/// CalendarValueAccessor is a control value accessor that convert between datetime to string
class CalendarValueAccessor extends ControlValueAccessor<List<DateTime?>, String> {
  @override
  String? modelToViewValue(List<DateTime?>? modelValue) {
    return modelValue == null ? '' : modelValue.map((d) => d == null ? '' : d.formattedDate).join('|');
  }

  @override
  List<DateTime?>? viewToModelValue(String? viewValue) {
    return viewValue == null ? [] : viewValue.split('|').map((d) => d == '' ? null : d.parseDate).toList();
  }
}
