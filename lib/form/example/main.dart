import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_date_range_picker/reactive_date_range_picker.dart';
import 'package:reactive_touch_spin/reactive_touch_spin.dart';
import 'package:reactive_phone_form_field/reactive_phone_form_field.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:intl/intl.dart';
import '../form.dart';

main() => app.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      appName: 'form example',
      routesBuilder: () => {
        '/': (context, state, data) => const FormExample(),
      },
    );

final formGroup = fb.group({
  'rating': FormControl<double>(value: 2.5),
  'raw': FormControl<String>(value: null),
  'phone': FormControl<PhoneNumber>(
    value: const PhoneNumber(
      isoCode: IsoCode.UA,
      nsn: '933456789',
    ),
  ),
  'input': FormControl<String>(value: null),
  'future': FormControl<String>(validators: [
    Validators.required,
  ]),
  'name': ['', Validators.required],
  'address': [''],
  'email': [
    '',
    Validators.required,
    Validators.email,
  ],
  'selection': [''],
  'password': [
    '',
    Validators.required,
    Validators.minLength(8),
  ],
  'payment': [0, Validators.required],
  'switch': [false],
  'progress': [50.0, Validators.min(50.0)],
  'checkbox': [true],
  'checkbox2': [true],
  'sendNotifications': [false, Validators.required],
  'dateTime': DateTime.now(),
  'time': TimeOfDay.now(),
  'dateRange': FormControl<DateTimeRange>(),
  'touchSpin': FormControl<int>(value: 10),
});

class NumValueAccessor extends ControlValueAccessor<int, num> {
  final int fractionDigits;

  NumValueAccessor({
    this.fractionDigits = 2,
  });

  @override
  num? modelToViewValue(int? modelValue) {
    return modelValue;
  }

  @override
  int? viewToModelValue(num? viewValue) {
    return viewValue?.toInt();
  }
}

class FormExample extends StatelessWidget {
  const FormExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _form(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 45,
      textStyle: TextStyle(fontSize: 24, color: colorScheme.onBackground),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colorScheme.primary, width: 2),
    );
    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
        //border: Border.all(color: Colors.grey.shade300, width: 1),
        );
    return ShimmerForm(
      showShimmer: false,
      formGroup: formGroup,
      child: Column(
        children: <Widget>[
          OutlinedButton(
            child: const Text('is allow to exit'),
            onPressed: () {
              isAllowToExit(formGroup: formGroup, submitCallback: (context) async => true);
            },
          ),
          RatingField<double>(
            formControlName: 'rating',
            allowHalfRating: true,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          ReactiveRawAutocomplete<String, String>(
            formControlName: 'raw',
            optionsBuilder: (TextEditingValue textEditingValue) {
              List<String> options = <String>[
                'aardvark',
                'bobcat',
                'chameleon',
              ];
              return options.where((String option) {
                return option.contains(textEditingValue.text.toLowerCase());
              });
            },
            optionsViewBuilder:
                (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4.0,
                  child: SizedBox(
                    height: 200.0,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return GestureDetector(
                          onTap: () {
                            onSelected(option);
                          },
                          child: ListTile(
                            title: Text(option),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          ReactivePhoneFormField<PhoneNumber>(
            formControlName: 'phone',
            focusNode: FocusNode(),
          ),
          p(),
          FormPinPut<String>(
              formControlName: 'input',
              length: 6,
              autofocus: true,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              pinAnimationType: PinAnimationType.fade,
              showCursor: false,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ]),
          br(),
          Submit(
            onSubmit: (context) async {
              debugPrint(formGroup.value.toString());
              return true;
            },
          ),
          FutureField<String>(
            onPressed: (context, String? text) async {
              return 'ax';
            },
            valueBuilder: (String? value) => value != null ? Text(value) : const SizedBox(),
            formControlName: 'future',
            decoration: const InputDecoration(
              labelText: 'future name',
              hintText: 'please input future name',
            ),
            validationMessages: {
              ValidationMessage.required: (error) => 'The name must not be empty',
            },
          ),
          br(),
          ReactiveTextField(
            formControlName: 'name',
            decoration: const InputDecoration(
              labelText: 'Your name',
              hintText: 'please input your name',
            ),
            validationMessages: {
              ValidationMessage.required: (error) => 'The name must not be empty',
            },
          ),
          EmailField(
            formControlName: 'email',
            decoration: const InputDecoration(
              labelText: 'Your email',
              hintText: 'please input your email',
            ),
            validationMessages: {
              ValidationMessage.required: (error) => 'The email must not be empty',
              ValidationMessage.email: (error) =>
                  context.i18n.fieldValueInvalid.replaceAll('%1', 'Your email').replaceAll('%2', 'johndoe@domain.com'),
            },
          ),
          ReactiveTextField(
            formControlName: 'address',
            inputFormatters: [
              LengthLimitingTextInputFormatter(8),
            ],
            decoration: const InputDecoration(
              labelText: 'Your address',
              hintText: 'please input your address',
            ),
            validationMessages: {
              ValidationMessage.required: (error) => 'The address must not be empty',
            },
          ),
          ReactiveTextField(
            formControlName: 'selection',
            decoration: InputDecoration(
              labelText: 'Your selection',
              hintText: 'please search a selection',
              suffixIcon: ElevatedButton.icon(
                  style: const ButtonStyle(visualDensity: VisualDensity.compact),
                  icon: const Icon(Icons.bluetooth),
                  label: const Text('Search'),
                  onPressed: () {
                    formGroup.control('selection').value = 'option 1';
                  }),
            ),
            readOnly: true,
            validationMessages: {
              ValidationMessage.required: (error) => 'The email must not be empty',
            },
          ),
          ReactiveTextField(
            formControlName: 'password',
            obscureText: true,
            validationMessages: {
              ValidationMessage.required: (error) => 'The password must not be empty',
              ValidationMessage.minLength: (error) => 'The password min length is 8',
            },
          ),
          ReactiveDropdownField<int>(
            formControlName: 'payment',
            hint: const Text('Select payment...'),
            items: const [
              DropdownMenuItem(
                value: 0,
                child: Text('Free'),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text('Visa'),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('Mastercard'),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text('PayPal'),
              ),
            ],
          ),
          ReactiveSlider(
            formControlName: 'progress',
            max: 100,
            divisions: 100,
            labelBuilder: (double value) => '${value.toStringAsFixed(2)}%',
          ),
          ReactiveSwitch(
            formControlName: 'switch',
          ),
          ReactiveCheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            formControlName: 'checkbox',
            title: const Text('check option1'),
          ),
          ReactiveCheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            formControlName: 'checkbox2',
            title: const Text('check option2'),
          ),
          ReactiveRadioListTile(
            title: const Text('Send notifications'),
            value: true,
            formControlName: 'sendNotifications',
          ),
          ReactiveRadioListTile(
            title: const Text('Not Send notifications'),
            value: false,
            formControlName: 'sendNotifications',
          ),
          ReactiveTextField<TimeOfDay>(
            formControlName: 'time',
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Birthday time',
              suffixIcon: ReactiveTimePicker(
                formControlName: 'time',
                builder: (context, picker, child) {
                  return IconButton(
                    onPressed: picker.showPicker,
                    icon: const Icon(Icons.access_time),
                  );
                },
              ),
            ),
          ),
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
          ReactiveDateRangePicker(
            formControlName: 'dateRange',
            decoration: const InputDecoration(
              labelText: 'Date range',
              helperText: '',
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
          ReactiveTouchSpin<int>(
            formControlName: 'touchSpin',
            valueAccessor: NumValueAccessor(),
            displayFormat: NumberFormat()..minimumFractionDigits = 0,
            min: 1,
            max: 99,
            step: 1,
            textStyle: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              labelText: "Order quantity",
              helperText: '',
            ),
          ),
          const Divider(),
          br(),
          Submit(
            onSubmit: (context) async {
              await Future.delayed(const Duration(seconds: 5));
              debugPrint('form submitted');
              return true;
            },
          ),
          br(),
          const Submit(child: Text('my Submit')),
          br(),
          OutlinedButton(
            child: const Text('Submit very long waiting form'),
            onPressed: () async {
              await Future.delayed(const Duration(seconds: 5));
            },
          ),
          br(),
          const OutlinedButton(
            onPressed: null,
            child: Text('Submit very long waiting form'),
          ),
          br(),
        ],
      ),
    );
  }
}
