import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;

/// [DateDisplayValueAccessor] is a control value accessor that convert between datetime to string
class DateDisplayValueAccessor extends ControlValueAccessor<DateTime, String> {
  @override
  String? modelToViewValue(DateTime? modelValue) {
    return modelValue == null ? '' : modelValue.formattedDate;
  }

  @override
  DateTime? viewToModelValue(String? viewValue) {
    return viewValue?.parseDate;
  }
}

/// [DateValueAccessor] is a control value accessor that convert between datetime to string
class DateValueAccessor extends ControlValueAccessor<DateTime?, String> {
  @override
  String? modelToViewValue(DateTime? modelValue) {
    return modelValue == null ? '' : modelValue.toIso8601String();
  }

  @override
  DateTime? viewToModelValue(String? viewValue) {
    return viewValue != null ? DateTime.parse(viewValue) : null;
  }
}

/// [DateRangeDisplayValueAccessor] is a control value accessor that convert between datetime to string
class DateRangeDisplayValueAccessor extends ControlValueAccessor<DateTimeRange?, String> {
  @override
  String? modelToViewValue(DateTimeRange? modelValue) {
    return modelValue == null ? '' : '${modelValue.start.formattedDate} - ${modelValue.end.formattedDate}';
  }

  @override
  DateTimeRange? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) {
      return null;
    }
    final dates = viewValue.split(' - ');
    if (dates.length != 2) {
      return null;
    }
    return DateTimeRange(start: dates[0].parseDate, end: dates[1].parseDate);
  }
}

/// [DateRangeValueAccessor] is a control value accessor that convert between datetime to string
class DateRangeValueAccessor extends ControlValueAccessor<DateTimeRange?, String> {
  @override
  String? modelToViewValue(DateTimeRange? modelValue) {
    return modelValue == null ? '' : '${modelValue.start.toIso8601String()}_${modelValue.end.toIso8601String()}';
  }

  @override
  DateTimeRange? viewToModelValue(String? viewValue) {
    if (viewValue == null || viewValue.isEmpty) {
      return null;
    }
    final dates = viewValue.split('_');
    if (dates.length != 2) {
      return null;
    }
    return DateTimeRange(start: DateTime.parse(dates[0]), end: DateTime.parse(dates[1]));
  }
}

/// [DateMultiDisplayValueAccessor] is a control value accessor that convert between datetime to string
class DateMultiDisplayValueAccessor extends ControlValueAccessor<List<DateTime>, String> {
  @override
  String? modelToViewValue(List<DateTime?>? modelValue) {
    return modelValue == null ? '' : modelValue.map((d) => d == null ? '' : d.formattedDate).join('; ');
  }

  @override
  List<DateTime>? viewToModelValue(String? viewValue) {
    return viewValue == null ? [] : viewValue.split('; ').map((d) => d.parseDate).toList();
  }
}

/// [DateMultiValueAccessor] is a control value accessor that convert between datetime to string
class DateMultiValueAccessor extends ControlValueAccessor<List<DateTime>, String> {
  @override
  String? modelToViewValue(List<DateTime?>? modelValue) {
    return modelValue == null ? '' : modelValue.map((d) => d == null ? '' : d.formattedDate).join(';');
  }

  @override
  List<DateTime>? viewToModelValue(String? viewValue) {
    return viewValue == null ? [] : viewValue.split(';').map((d) => d.parseDate).toList();
  }
}
