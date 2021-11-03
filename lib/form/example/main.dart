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
    dropdownFocus.dispose();
    clickFocus.dispose();
    emailFocus.dispose();
    dateFocus.dispose();
    checkFocus.dispose();
    submitFocus.dispose();
    super.dispose();
  }

  final inputFocus = FocusNode();

  final dropdownFocus = FocusNode();

  final clickFocus = FocusNode(debugLabel: 'clickFocus');

  final emailFocus = FocusNode();

  final dateFocus = FocusNode();

  final checkFocus = FocusNode();

  final submitFocus = FocusNode();
}

final GlobalKey btnMenu = GlobalKey();

final GlobalKey btnTooltip = GlobalKey();

final textController = TextEditingController();

final dropdownController = ValueNotifier<int>(0);

final dateController = ValueNotifier<DateTime?>(null);

final clickController = TextEditingController();

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
                    InputField(
                      key: const Key('test-input'),
                      controller: textController,
                      label: 'input field label',
                      hint: 'please input text',
                      require: 'input is required',
                      focusNode: pFormPlayground.inputFocus,
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
                      require: 'you must select 1 item',
                      focusNode: pFormPlayground.dropdownFocus,
                      nextFocusNode: pFormPlayground.clickFocus,
                    ),
                    br(),
                    ClickField(
                      key: const Key('test-click'),
                      controller: clickController,
                      label: 'click field label',
                      hint: 'click here to set value',
                      onClicked: (String text) async {
                        return "hello";
                      },
                      require: 'you must click to set value',
                      focusNode: pFormPlayground.clickFocus,
                      nextFocusNode: pFormPlayground.emailFocus,
                    ),
                    br(),
                    EmailField(
                      key: const Key('test-email'),
                      controller: emailController,
                      label: 'email field',
                      focusNode: pFormPlayground.emailFocus,
                    ),
                    const SizedBox(height: 20),
                    DateField(
                      key: const Key('test-date'),
                      controller: dateController,
                      label: 'date field',
                      focusNode: pFormPlayground.dateFocus,
                      require: 'you must select a date',
                    ),
                    const SizedBox(height: 20),
                    Button(
                      width: 240,
                      key: const Key('submitForm'),
                      label: 'Submit form',
                      form: _keyForm,
                      onClick: () async {
                        //await Future.delayed(Duration(seconds: 1));
                      },
                    ),
                    const SizedBox(height: 20),
                    Separator(height: 2, color: Colors.red[200]!),
                    const SizedBox(height: 20),
                    Button(
                      elevation: 0,
                      color: Colors.red[400]!,
                      key: const Key('submitLong'),
                      label: 'Submit very long waiting form',
                      onClick: () async {
                        await Future.delayed(const Duration(seconds: 5));
                      },
                    ),
                    const SizedBox(height: 20),
                    Button(
                      elevation: 0,
                      color: Colors.green[400]!,
                      key: const Key('submitSelect'),
                      label: 'Select',
                      onClick: () async {
                        await Future.delayed(const Duration(seconds: 1));
                      },
                    ),
                    const SizedBox(height: 20),
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
