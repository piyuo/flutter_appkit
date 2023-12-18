import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/intl.dart' as intl;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/delta/delta.dart' as delta;

class DateRangePicker extends ReactiveFormField<DateTimeRange, String> {
  /// Creates a [DateRangePicker] that wraps the function [showDateRangePicker].
  ///
  /// Can optionally provide a [formControl] to bind this widget to a control.
  ///
  /// Can optionally provide a [formControlName] to bind this ReactiveFormField
  /// to a [FormControl].
  ///
  /// Must provide one of the arguments [formControl] or a [formControlName],
  /// but not both at the same time.
  ///
  /// The parameter [transitionBuilder] is the equivalent of [builder]
  /// parameter in the [showTimePicker].
  ///
  /// For documentation about the various parameters, see the [showDateRangePicker]
  /// function parameters.
  DateRangePicker({
    super.key,
    super.formControlName,
    super.formControl,
    ControlValueAccessor<DateTimeRange, String>? valueAccessor,
    super.validationMessages,
    ShowErrorsFunction? super.showErrors,
    InputDecoration? decoration,
    Widget Function(BuildContext, DateTimeRange? range, String? text)? widgetBuilder,
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
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendarOnly,
    Locale? locale,
    TextDirection? textDirection,
    RouteSettings? routeSettings,
  }) : super(
          valueAccessor: valueAccessor ?? DateRangePickerValueAccessor(),
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

            final effectiveValueAccessor = valueAccessor ?? DateRangePickerValueAccessor();

            final effectiveLastDate = lastDate ?? DateTime(2100);

            return IgnorePointer(
                ignoring: !field.control.enabled,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      final dateRange = await showDateRangePicker(
                        builder: (context, child) {
                          // _DateRangePickerDialogState has some issue with the colorScheme, remove this Theme when it's fixed
                          final colorScheme = Theme.of(context).colorScheme;
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: colorScheme.brightness == Brightness.light
                                  ? colorScheme.copyWith(surface: colorScheme.primary)
                                  : null,
                            ),
                            child: child!,
                          );
                        },
                        context: field.context,
                        initialDateRange: field.control.value,
                        firstDate: firstDate ?? DateTime(1900),
                        lastDate: effectiveLastDate,
                        currentDate: currentDate,
                        initialEntryMode: initialEntryMode,
                        helpText: helpText,
                        cancelText: cancelText,
                        confirmText: confirmText,
                        saveText: saveText,
                        errorFormatText: errorFormatText,
                        errorInvalidText: errorInvalidText,
                        errorInvalidRangeText: errorInvalidRangeText,
                        fieldStartHintText: fieldStartHintText,
                        fieldEndHintText: fieldEndHintText,
                        fieldStartLabelText: fieldStartLabelText,
                        fieldEndLabelText: fieldEndLabelText,
                        locale: locale,
                        useRootNavigator: useRootNavigator,
                        routeSettings: routeSettings,
                        textDirection: textDirection,
                      );

                      if (dateRange == null) {
                        return;
                      }

                      field.control.markAsTouched();
                      field.didChange(effectiveValueAccessor.modelToViewValue(dateRange));
                    },
                    child: widgetBuilder != null
                        ? widgetBuilder(field.context, field.control.value, field.value)
                        : InputDecorator(
                            decoration: effectiveDecoration.copyWith(
                              errorText: field.errorText,
                              enabled: field.control.enabled,
                            ),
                            isEmpty: isEmptyValue && effectiveDecoration.hintText == null,
                            child: Text(
                              field.value ?? '',
                              style: Theme.of(field.context).textTheme.titleMedium?.merge(style),
                            ),
                          ),
                  ),
                ));
          },
        );
}

/// Represents a control value accessor that convert between data types
/// [DateTimeRange] and [String].
class DateRangePickerValueAccessor extends ControlValueAccessor<DateTimeRange, String> {
  final intl.DateFormat dateTimeFormat;
  final String delimiter;

  DateRangePickerValueAccessor({intl.DateFormat? dateTimeFormat, this.delimiter = ' - '})
      : dateTimeFormat = dateTimeFormat ?? intl.DateFormat('yyyy/MM/dd');

  @override
  String? modelToViewValue(DateTimeRange? modelValue) {
    return modelValue == null
        ? ''
        : '${dateTimeFormat.format(modelValue.start)}$delimiter${dateTimeFormat.format(modelValue.end)}';
  }

  @override
  DateTimeRange? viewToModelValue(String? viewValue) {
    final dateRange = viewValue?.trim().split(delimiter);

    return dateRange == null || dateRange.isEmpty
        ? null
        : DateTimeRange(start: dateTimeFormat.parse(dateRange.first), end: dateTimeFormat.parse(dateRange.last));
  }
}

/// BigDateLabel show one big date and the weekday name.
class BigDateLabel extends StatelessWidget {
  const BigDateLabel({
    required this.date,
    super.key,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          date.day.toString(),
          style: delta.mergeTextStyle(
            Theme.of(context).textTheme.displayMedium,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date.formattedMonth,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              date.formattedWeekdayAware(context),
              style: delta.mergeTextStyle(
                Theme.of(context).textTheme.bodyMedium,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// buildBigDateRange is a helper function to build a BigDateRange widget.
Widget buildBigDateRange(BuildContext context, DateTimeRange? range, String? text) {
  final colorScheme = Theme.of(context).colorScheme;
  final actualRange = range ?? DateTimeRange(start: DateTime.now(), end: DateTime.now());
  return Row(children: [
    BigDateLabel(
      date: actualRange.start,
    ),
    Expanded(
      child: Text(
        ' - ',
        textAlign: TextAlign.center,
        style: delta.mergeTextStyle(
          Theme.of(context).textTheme.headlineLarge,
          color: colorScheme.outline,
        ),
      ),
    ),
    BigDateLabel(
      date: actualRange.end,
    ),
  ]);
}
