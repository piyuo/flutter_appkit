import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;
import 'calendar.dart';

/// DateMultiPicker is a convenience widget that can  multi date
class DateMultiPicker extends ReactiveFormField<List<DateTime?>, String> {
  DateMultiPicker({
    String? formControlName,
    FormControl<List<DateTime?>>? formControl,
    ControlValueAccessor<List<DateTime?>, String>? valueAccessor,
    Map<String, ValidationMessageFunction>? validationMessages,
    ShowErrorsFunction? showErrors,
    InputDecoration? decoration,
    bool showClearIcon = true,
    Widget clearIcon = const Icon(Icons.clear),
    TextStyle? style,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? saveText,
    String? errorFormatText,
    String? errorInvalidText,
    String? errorInvalidRangeText,
    String? fieldStartHintText,
    String? fieldEndHintText,
    String? fieldStartLabelText,
    String? fieldEndLabelText,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    RouteSettings? routeSettings,
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
          valueAccessor: valueAccessor ?? CalendarValueAccessor(),
          showErrors: showErrors,
          builder: (field) {
            Widget? suffixIcon = decoration?.suffixIcon;
            final isEmptyValue = field.value == null || field.value.toString().isEmpty;

            if (showClearIcon && !isEmptyValue) {
              suffixIcon = InkWell(
                borderRadius: BorderRadius.circular(25),
                child: clearIcon,
                onTap: () {
                  field.control.markAsTouched();
                  field.didChange(null);
                },
              );
            }
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme)
                .copyWith(suffixIcon: suffixIcon);

            final effectiveValueAccessor = valueAccessor ?? CalendarValueAccessor();

            final colorScheme = Theme.of(field.context).colorScheme;
            buildChips(List<DateTime?> dateTimes) {
              return dateTimes
                  .map((date) => Padding(
                      padding: delta.phoneScreen
                          ? const EdgeInsets.fromLTRB(4, 0, 4, 0)
                          : const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Chip(
                        elevation: 2,
                        label: Wrap(children: [
                          Text(
                            date!.formattedDate,
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            date.formattedWeekdayAwareShort(field.context),
                            style: TextStyle(
                              color: colorScheme.primaryContainer,
                            ),
                          ),
                        ]),
                        deleteIcon: Icon(
                          Icons.cancel_outlined,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                        onDeleted: () {
                          field.control.markAsTouched();
                          field.didChange(effectiveValueAccessor.modelToViewValue(
                            dateTimes.where((element) => element != date).toList(),
                          ));
                        },
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      )))
                  .toList();
            }

            return IgnorePointer(
              ignoring: !field.control.enabled,
              child: GestureDetector(
                onTap: () async {
                  final dateRange = await showCalendarDatePicker2Dialog(
                    context: field.context,
                    config: CalendarDatePicker2WithActionButtonsConfig(
                      calendarType: CalendarDatePicker2Type.multi,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      currentDate: currentDate,
                      dayBuilder: dayBuilder,
                    ),
                    value: field.control.value ?? [],
                    dialogSize: const Size(325, 400),
                    useRootNavigator: useRootNavigator,
                    routeSettings: routeSettings,
                    builder: builder,
                  );

                  if (dateRange == null) {
                    return;
                  }
                  field.control.markAsTouched();
                  field.didChange(effectiveValueAccessor.modelToViewValue(dateRange));
                },
                child: InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: field.errorText,
                    enabled: field.control.enabled,
                  ),
                  isEmpty: isEmptyValue && effectiveDecoration.hintText == null,
                  child: field.control.value == null
                      ? const SizedBox()
                      : Wrap(
                          children: buildChips(field.control.value!),
                        ),
                ),
              ),
            );
          },
        );
}
