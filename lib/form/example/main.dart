import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/app/app.dart' as app;
import '../form.dart';

main() => app.start(
      appName: 'form example',
      routes: (_) => const FormExample(),
    );

class FormExampleProvider extends ChangeNotifier {
  @override
  dispose() {
    inputFocus.dispose();
    input2Focus.dispose();
    dropdownFocus.dispose();
    clickFocus.dispose();
    emailFocus.dispose();
    dateFocus.dispose();
    checkFocus.dispose();
    submitFocus.dispose();
    super.dispose();
  }

  final inputFocus = FocusNode();

  final input2Focus = FocusNode();

  final dropdownFocus = FocusNode();

  final radioFocus = FocusNode(debugLabel: 'radioFocus');

  final clickFocus = FocusNode(debugLabel: 'clickFocus');

  final clickValueFocus = FocusNode();

  final emailFocus = FocusNode();

  final dateFocus = FocusNode();

  final datetimeFocus = FocusNode();

  final timeFocus = FocusNode();

  final checkFocus = FocusNode();

  final submitFocus = FocusNode();
}

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final textController = TextEditingController();

final dropdownController = ValueNotifier<int>(0);

final dateController = ValueNotifier<DateTime?>(null);

final radioController = ValueNotifier<String>('50');

final clickController = ValueNotifier<String?>(null);

final clickValueController = ValueNotifier<String?>('hello');

final emailController = TextEditingController();

final _keyForm = GlobalKey<FormState>();

class FormExample extends StatelessWidget {
  const FormExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormExampleProvider>(
      create: (context) => FormExampleProvider(),
      child: Consumer<FormExampleProvider>(builder: (context, pFormPlayground, child) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _keyForm,
                child: Column(
                  children: [
                    RadioGroup<String>(
                        key: const Key('test-radio'),
                        controller: radioController,
                        focusNode: pFormPlayground.radioFocus,
                        nextFocusNode: pFormPlayground.clickFocus,
                        label: 'Paper Size',
                        items: const {
                          '50': '50 mm',
                          '80': '80 mm',
                        }),
                    ClickField<String>(
                      key: const Key('test-click'),
                      controller: clickController,
                      label: 'click field label',
                      onClicked: (String? text) async {
                        return "hello";
                      },
                      valueToString: (String? value) => value ?? '',
                      requiredField: true,
                      focusNode: pFormPlayground.clickFocus,
                      nextFocusNode: pFormPlayground.emailFocus,
                    ),
                    br(),
                    ClickField<String>(
                      key: const Key('test-click-value'),
                      controller: clickValueController,
                      label: 'click value field',
                      onClicked: (String? text) async {
                        return "hello";
                      },
                      valueToString: (String? value) => value ?? '',
                      focusNode: pFormPlayground.clickValueFocus,
                      requiredField: true,
                    ),
                    br(),
                    InputField(
                      key: const Key('test-input'),
                      controller: textController,
                      label: 'input field label',
                      hint: 'please input text',
                      requiredField: true,
                      focusNode: pFormPlayground.inputFocus,
                    ),
                    br(),
                    InputField(
                      key: const Key('test-input2'),
                      decoration: InputDecoration(
                        labelText: 'input field label',
                        hintText: 'please input text',
                        suffixIcon: ElevatedButton.icon(
                            style: const ButtonStyle(visualDensity: VisualDensity.compact),
                            icon: const Icon(Icons.bluetooth),
                            label: const Text('Search'),
                            onPressed: () {
                              textController.text = 'searched';
                            }),
/*                        suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              textController.text = 'searched';
                            }),*/
                      ),
                      readOnly: true,
                      controller: textController,
                      requiredField: true,
                      focusNode: pFormPlayground.input2Focus,
                    ),
                    br(),
                    DropdownField(
                      key: const Key('test-dropdown'),
                      controller: dropdownController,
                      items: const {
                        0: "000",
                        1: "111",
                      },
                      label: 'dropdown field label',
                      requiredField: true,
                      focusNode: pFormPlayground.dropdownFocus,
                      nextFocusNode: pFormPlayground.clickFocus,
                    ),
                    br(),
                    EmailField(
                      key: const Key('test-email'),
                      controller: emailController,
                      label: 'email field',
                      focusNode: pFormPlayground.emailFocus,
                    ),
                    br(),
                    DateField(
                      key: const Key('test-date'),
                      controller: dateController,
                      label: 'date field',
                      focusNode: pFormPlayground.dateFocus,
                      requiredField: true,
                    ),
                    br(),
                    DateField(
                      key: const Key('test-datetime'),
                      controller: dateController,
                      label: 'datetime field',
                      mode: DateFieldMode.datetime,
                      focusNode: pFormPlayground.datetimeFocus,
                      requiredField: true,
                    ),
                    br(),
                    DateField(
                      key: const Key('test-ime'),
                      controller: dateController,
                      label: 'time field',
                      mode: DateFieldMode.time,
                      focusNode: pFormPlayground.timeFocus,
                      requiredField: true,
                    ),
                    br(),
                    Button(
                      width: 240,
                      key: const Key('submitForm'),
                      label: 'Submit form',
                      form: _keyForm,
                      onClick: () async {
                        debugPrint('form submitted');
                        await Future.delayed(const Duration(seconds: 5));
                      },
                    ),
                    br(),
                    Button(
                      elevation: 0,
                      color: Colors.red.shade400,
                      key: const Key('submitLong'),
                      label: 'Submit very long waiting form',
                      onClick: () async {
                        await Future.delayed(const Duration(seconds: 5));
                      },
                    ),
                    br(),
                    Button(
                      elevation: 0,
                      color: Colors.green.shade400,
                      key: const Key('submitSelect'),
                      label: 'Select',
                      onClick: () async {
                        await Future.delayed(const Duration(seconds: 1));
                      },
                    ),
                    br(),
                    AnimateButton(
                      'animate button',
                      onClick: () async {
                        await Future.delayed(const Duration(seconds: 5));
                        return true;
                      },
                    ),
                    p(),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
