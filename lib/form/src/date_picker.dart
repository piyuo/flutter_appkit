import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    required this.firstDate,
    required this.lastDate,
    this.formControlName,
    this.formControl,
    this.validationMessages,
    this.showErrors,
    this.currentDate,
    this.decoration,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.inputFormatters,
    super.key,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final String? formControlName;
  final FormControl<DateTime?>? formControl;
  final Map<String, ValidationMessageFunction>? validationMessages;
  final ShowErrorsFunction? showErrors;
  final DateTime? currentDate;
  final InputDecoration? decoration;
  final TextCapitalization textCapitalization;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return ReactiveDatePicker<DateTime>(
        formControlName: formControlName,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (context, picker, child) {
          return ReactiveTextField<DateTime>(
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
        });
  }
}


/*
          ReactiveTextField<DateTime>(
            formControlName: 'dateTime',
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Birthday',
              suffixIcon: ReactiveDatePicker<DateTime>(
                formControlName: 'dateTime',
                firstDate: DateTime(1985),
                lastDate: DateTime(2030),
                builder: (context, picker, child) {
                  return IconButton(
                    onPressed: picker.showPicker,
                    icon: const Icon(Icons.date_range),
                  );
                },
              ),
            ),
          ),

 */