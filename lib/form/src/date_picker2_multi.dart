import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'date_value_accessor.dart';
import 'date_picker2.dart';

/// DatePicker2 is a multi date picker using calendar_date_picker2 package
class DatePicker2Multi extends ReactiveFormField<List<DateTime>, String> {
  DatePicker2Multi({
    super.formControlName,
    super.formControl,
    super.validationMessages,
    ShowErrorsFunction? super.showErrors,
    InputDecoration? decoration,
    bool showClearIcon = true,
    Widget clearIcon = const Icon(Icons.clear),
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
    TextStyle? style,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    super.key,
  }) : super(
          valueAccessor: DateMultiValueAccessor(),
          builder: (field) {
            return ReactiveTextField<List<DateTime>>(
              formControlName: formControlName,
              decoration: decoration ?? const InputDecoration(),
              valueAccessor: DateMultiDisplayValueAccessor(),
              onTap: (FormControl control) async {
                final dates = await showCalendarDatePicker2Dialog(
                  context: field.context,
                  config: CalendarDatePicker2WithActionButtonsConfig(
                    calendarType: CalendarDatePicker2Type.multi,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    currentDate: currentDate,
                    dayBuilder: dayBuilder,
                  ),
                  value: field.control.value ?? [],
                  dialogSize: kDatePicker2DefaultSize,
                  useRootNavigator: useRootNavigator,
                  routeSettings: routeSettings,
                  builder: builder,
                );

                if (dates == null) {
                  return;
                }

                List<DateTime> dateRange = [];
                for (final date in dates) {
                  if (date != null) {
                    dateRange.add(date);
                  }
                }

                field.control.markAsTouched();
                final effectiveValueAccessor = DateMultiValueAccessor();
                field.didChange(dates.isEmpty ? null : effectiveValueAccessor.modelToViewValue(dateRange));
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


/*
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
            List<Widget> buildChips() {
              List<DateTime>? dateTimes = field.control.value;
              if (dateTimes == null) {
                return [];
              }
              return dateTimes
                  .map(
                    (date) => Padding(
                      padding: delta.phoneScreen
                          ? const EdgeInsets.fromLTRB(4, 0, 4, 0)
                          : const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Chip(
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        label: Wrap(children: [
                          Text(
                            date.formattedDate,
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
                          final newDateTimes = dateTimes.where((element) => element != date).toList();
                          if (newDateTimes.isEmpty) {
                            field.control.updateValue(null);
                            return;
                          }
                          field.control.markAsTouched();
                          field.didChange(effectiveValueAccessor.modelToViewValue(newDateTimes));
                        },
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                  .toList();
            }

            return IgnorePointer(
              ignoring: !field.control.enabled,
              child: GestureDetector(
                onTap: () async {
                  final result = await showCalendarDatePicker2Dialog(
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

                  if (result == null) {
                    return; // user canceled
                  }
                  List<DateTime> dateRange = [];
                  for (final date in result) {
                    if (date != null) {
                      dateRange.add(date);
                    }
                  }

                  if (dateRange.isEmpty) {
                    field.control.updateValue(null);
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
                          children: buildChips(),
                        ),
                ),
              ),
            );
          }
*/