library reactive_flutter_rating_bar;

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

export 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// A [RatingField] is rating field
/// ```dart
/// RatingField<double>(
///  formControlName: 'rating',
///  allowHalfRating: true,
///   itemBuilder: (context, _) => const Icon(
///    Icons.star,
///    color: Colors.amber,
///  ),
/// ),
/// ```
class RatingField<T> extends ReactiveFormField<T, double> {
  /// A [RatingField] is rating field
  /// ```dart
  /// RatingField<double>(
  ///  formControlName: 'rating',
  ///  allowHalfRating: true,
  ///   itemBuilder: (context, _) => const Icon(
  ///    Icons.star,
  ///    color: Colors.amber,
  ///  ),
  /// ),
  /// ```
  RatingField({
    Key? key,
    String? formControlName,
    FormControl<T>? formControl,
    ValidationMessagesFunction<T>? validationMessages,
    ControlValueAccessor<T, double>? valueAccessor,
    ShowErrorsFunction? showErrors,
    InputDecoration decoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      isDense: true,
      isCollapsed: true,
    ),
    Color? glowColor,
    double? maxRating,
    TextDirection? textDirection,
    Color? unratedColor,
    bool allowHalfRating = false,
    Axis direction = Axis.horizontal,
    bool glow = true,
    double glowRadius = 2,
    bool ignoreGestures = false,
    int itemCount = 5,
    EdgeInsets itemPadding = EdgeInsets.zero,
    double itemSize = 40.0,
    double minRating = 0,
    bool tapOnlyMode = false,
    bool updateOnDrag = false,
    WrapAlignment wrapAlignment = WrapAlignment.start,
    required Widget Function(BuildContext, int) itemBuilder,
  }) : super(
          key: key,
          formControl: formControl,
          formControlName: formControlName,
          valueAccessor: valueAccessor,
          validationMessages: validationMessages,
          showErrors: showErrors,
          builder: (field) {
            final InputDecoration effectiveDecoration =
                decoration.applyDefaults(Theme.of(field.context).inputDecorationTheme);

            final child = RatingBar.builder(
              itemBuilder: itemBuilder,
              onRatingUpdate: field.didChange,
              glowColor: glowColor,
              maxRating: maxRating,
              textDirection: textDirection,
              unratedColor: unratedColor,
              allowHalfRating: allowHalfRating,
              direction: direction,
              glow: glow,
              glowRadius: glowRadius,
              ignoreGestures: ignoreGestures,
              initialRating: field.value ?? 0,
              itemCount: itemCount,
              itemPadding: itemPadding,
              itemSize: itemSize,
              minRating: minRating,
              tapOnlyMode: tapOnlyMode,
              updateOnDrag: updateOnDrag,
              wrapAlignment: wrapAlignment,
            );

            return Listener(
              onPointerDown: (_) {
                if (field.control.enabled) {
                  field.control.markAsTouched();
                }
              },
              child: InputDecorator(
                textAlign: TextAlign.center,
                decoration: effectiveDecoration.copyWith(
                  errorText: field.errorText,
                  enabled: field.control.enabled,
                ),
                child: child,
              ),
            );
          },
        );
}
