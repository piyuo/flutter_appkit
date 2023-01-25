import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:libcli/validator/validator.dart' as validator;
import 'package:libcli/i18n/i18n.dart' as i18n;

/// A [EmailField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [ReactiveTextField].
///
/// A [ReactiveForm] ancestor is required.
///
/// ```dart
/// EmailField(
///    formControlName: 'email',
///    decoration: const InputDecoration(
///      labelText: 'Your email',
///      hintText: 'please input your email',
///    ),
///    validationMessages: (control) => {
///      ValidationMessage.required: 'The email must not be empty',
///      ValidationMessage.email:
///          context.i18n.fieldValueInvalid.replaceAll('%1', 'Your email').replaceAll('%2', 'johndoe@domain.com'),
///    },
/// ),
/// ```
class EmailField<T> extends ReactiveFormField<T, String> {
  /// A [EmailField] that contains a [TextField].
  ///
  /// This is a convenience widget that wraps a [TextField] widget in a
  /// [ReactiveTextField].
  ///
  /// A [ReactiveForm] ancestor is required.
  ///
  /// ```dart
  /// EmailField(
  ///    formControlName: 'email',
  ///    decoration: const InputDecoration(
  ///      labelText: 'Your email',
  ///      hintText: 'please input your email',
  ///    ),
  ///    validationMessages: (control) => {
  ///      ValidationMessage.required: 'The email must not be empty',
  ///      ValidationMessage.email:
  ///          context.i18n.fieldValueInvalid.replaceAll('%1', 'Your email').replaceAll('%2', 'johndoe@domain.com'),
  ///    },
  /// ),
  /// ```
  EmailField({
    Key? key,
    String? formControlName,
    FormControl<T>? formControl,
    Map<String, ValidationMessageFunction>? validationMessages,
    ControlValueAccessor<T, String>? valueAccessor,
    ShowErrorsFunction? showErrors,
    InputDecoration decoration = const InputDecoration(),
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    EditableTextContextMenuBuilder? contextMenuBuilder,
    bool? showCursor,
    bool obscureText = false,
    String obscuringCharacter = '•',
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    GestureTapCallback? onTap,
    VoidCallback? onEditingComplete,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    VoidCallback? onSubmitted,
    FocusNode? focusNode,
    Iterable<String>? autofillHints,
    MouseCursor? mouseCursor,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    AppPrivateCommandCallback? onAppPrivateCommand,
    String? restorationId,
    ScrollController? scrollController,
    TextSelectionControls? selectionControls,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    TextEditingController? controller,
    Clip clipBehavior = Clip.hardEdge,
    bool enableIMEPersonalizedLearning = true,
    bool scribbleEnabled = true,
  })  : _textController = controller,
        super(
          key: key,
          formControl: formControl,
          formControlName: formControlName,
          valueAccessor: valueAccessor,
          validationMessages: validationMessages,
          showErrors: showErrors,
          builder: (ReactiveFormFieldState<T, String> field) {
            final state = field as _EmailFieldState<T>;
            final effectiveDecoration = decoration.applyDefaults(Theme.of(state.context).inputDecorationTheme);

            state._setFocusNode(focusNode);

            return Column(
              children: <Widget>[
                TextField(
                  controller: state._textController,
                  focusNode: state.focusNode,
                  decoration: effectiveDecoration.copyWith(errorText: state.errorText),
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  style: style,
                  strutStyle: strutStyle,
                  textAlign: textAlign,
                  textAlignVertical: textAlignVertical,
                  textDirection: textDirection,
                  textCapitalization: textCapitalization,
                  autofocus: autofocus,
                  contextMenuBuilder: contextMenuBuilder,
                  readOnly: readOnly,
                  showCursor: showCursor,
                  obscureText: obscureText,
                  autocorrect: autocorrect,
                  smartDashesType:
                      smartDashesType ?? (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
                  smartQuotesType:
                      smartQuotesType ?? (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
                  enableSuggestions: enableSuggestions,
                  maxLengthEnforcement: maxLengthEnforcement,
                  maxLines: maxLines,
                  minLines: minLines,
                  expands: expands,
                  maxLength: maxLength,
                  onChanged: field.didChange,
                  onTap: onTap,
                  onSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
                  onEditingComplete: onEditingComplete,
                  inputFormatters: inputFormatters,
                  enabled: field.control.enabled,
                  cursorWidth: cursorWidth,
                  cursorHeight: cursorHeight,
                  cursorRadius: cursorRadius,
                  cursorColor: cursorColor,
                  scrollPadding: scrollPadding,
                  scrollPhysics: scrollPhysics,
                  keyboardAppearance: keyboardAppearance,
                  enableInteractiveSelection: enableInteractiveSelection,
                  buildCounter: buildCounter,
                  autofillHints: autofillHints,
                  mouseCursor: mouseCursor,
                  obscuringCharacter: obscuringCharacter,
                  dragStartBehavior: dragStartBehavior,
                  onAppPrivateCommand: onAppPrivateCommand,
                  restorationId: restorationId,
                  scrollController: scrollController,
                  selectionControls: selectionControls,
                  selectionHeightStyle: selectionHeightStyle,
                  selectionWidthStyle: selectionWidthStyle,
                  clipBehavior: clipBehavior,
                  enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
                  scribbleEnabled: scribbleEnabled,
                ),
                state._suggest.isEmpty
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                              text: state.context.i18n.fieldHintYouMean,
                              style: TextStyle(
                                color: Colors.yellow[900],
                              ),
                            ),
                            TextSpan(
                              text: state._suggest,
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()..onTap = state._correctFromSuggestion,
                            )
                          ],
                        )),
                      ),
              ],
            );
          },
        );

  final TextEditingController? _textController;

  @override
  ReactiveFormFieldState<T, String> createState() => _EmailFieldState<T>();
}

class _EmailFieldState<T> extends ReactiveFormFieldState<T, String> {
  late TextEditingController _textController;

  late FocusController _focusController;

  FocusNode? _focusNode;

  @override
  FocusNode get focusNode => _focusNode ?? _focusController.focusNode;

  /// _suggest is email address suggestion
  String _suggest = '';

  @override
  void initState() {
    super.initState();
    _initializeTextController();
  }

  @override
  void subscribeControl() {
    _registerFocusController(FocusController());
    super.subscribeControl();
  }

  @override
  void unsubscribeControl() {
    _unregisterFocusController();
    super.unsubscribeControl();
  }

  @override
  void onControlValueChanged(dynamic value) {
    final effectiveValue = (value == null) ? '' : value.toString();
    _textController.value = _textController.value.copyWith(
      text: effectiveValue,
      selection: TextSelection.collapsed(offset: effectiveValue.length),
      composing: TextRange.empty,
    );

    super.onControlValueChanged(value);
  }

  @override
  ControlValueAccessor<T, String> selectValueAccessor() {
    if (control is FormControl<int>) {
      return IntValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<double>) {
      return DoubleValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<DateTime>) {
      return DateTimeValueAccessor() as ControlValueAccessor<T, String>;
    } else if (control is FormControl<TimeOfDay>) {
      return TimeOfDayValueAccessor() as ControlValueAccessor<T, String>;
    }

    return super.selectValueAccessor();
  }

  void _registerFocusController(FocusController focusController) {
    _focusController = focusController;
    control.registerFocusController(focusController);
    _focusController.addListener(_onFocusChange);
  }

  void _unregisterFocusController() {
    _focusController.removeListener(_onFocusChange);
    control.unregisterFocusController(_focusController);
    _focusController.dispose();
  }

  void _setFocusNode(FocusNode? focusNode) {
    if (_focusNode != focusNode) {
      _focusNode = focusNode;
      _unregisterFocusController();
      _registerFocusController(FocusController(focusNode: _focusNode));
    }
  }

  void _initializeTextController() {
    final initialValue = value;
    final currentWidget = widget as EmailField<T>;
    _textController =
        (currentWidget._textController != null) ? currentWidget._textController! : TextEditingController();
    _textController.text = initialValue == null ? '' : initialValue.toString();
  }

  /// _onFocusChange called when input focus changed
  void _onFocusChange() {
    if (!focusNode.hasFocus) {
      setState(() => _makeSuggestion());
    }
  }

  /// _makeSuggestion make suggestion from text
  void _makeSuggestion() {
    _suggest = '';
    if (_textController.text.isNotEmpty) {
      var suggest = validator.MailChecker(email: _textController.text).suggest();
      if (suggest != null) {
        _suggest = suggest.full;
      }
    }
  }

  /// _correctFromSuggestion corrects email address from suggestion
  _correctFromSuggestion() {
    setState(() {
      _textController.text = _suggest;
      didChange(_suggest);
      _suggest = '';
    });
  }
}
