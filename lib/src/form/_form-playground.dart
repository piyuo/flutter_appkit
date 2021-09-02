import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'input-field.dart';
import 'email-field.dart';
import 'submit.dart';
import 'animate-button.dart';
import 'dropdown-field.dart';
import 'tags.dart';
import 'click-field.dart';

class FormPlaygroundProvider extends ChangeNotifier {
  @override
  dispose() {
    inputFocus.dispose();
    dropdownFocus.dispose();
    clickFocus.dispose();
    emailFocus.dispose();
    checkFocus.dispose();
    submitFocus.dispose();
    super.dispose();
  }

  final inputFocus = FocusNode();

  final dropdownFocus = FocusNode();

  final clickFocus = FocusNode(debugLabel: 'clickFocus');

  final emailFocus = FocusNode();

  final checkFocus = FocusNode();

  final submitFocus = FocusNode();
}

class FormPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();

  final GlobalKey btnTooltip = GlobalKey();

  final textController = TextEditingController();

  final dropdownController = TextEditingController();

  final Map dropdownItems = {
    "aa": "11",
    "bb": "2",
  };

  final clickController = TextEditingController();

  final emailController = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormPlaygroundProvider>(
      create: (context) => FormPlaygroundProvider(),
      child: Consumer<FormPlaygroundProvider>(builder: (context, pFormPlayground, child) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _keyForm,
                child: Column(
                  children: [
                    InputField(
                      key: Key('test-input'),
                      controller: textController,
                      label: 'input field label',
                      hint: 'please input text',
                      require: 'input is required',
                      focusNode: pFormPlayground.inputFocus,
                    ),
                    br(),
                    DropdownField(
                      key: Key('test-dropdown'),
                      controller: dropdownController,
                      items: dropdownItems,
                      label: 'dropdown field label',
                      require: 'you must select 1 item',
                      focusNode: pFormPlayground.dropdownFocus,
                      nextFocusNode: pFormPlayground.clickFocus,
                    ),
                    br(),
                    ClickField(
                      key: Key('test-click'),
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
                      key: Key('test-email'),
                      controller: emailController,
                      label: 'email field',
                      focusNode: pFormPlayground.emailFocus,
                    ),
                    SizedBox(height: 20),
                    Submit(
                      key: Key('submitForm'),
                      label: 'Submit form',
                      form: _keyForm,
                      onClick: () async {
                        //await Future.delayed(Duration(seconds: 1));
                      },
                    ),
                    SizedBox(height: 20),
                    Submit(
                      key: Key('submitLong'),
                      label: 'Submit long waiting form',
                      onClick: () async {
                        await Future.delayed(Duration(seconds: 5));
                        return true;
                      },
                    ),
                    SizedBox(height: 20),
                    Submit(
                      key: Key('submitSelect'),
                      label: 'Select',
                      sizeLevel: 0.8,
                      onClick: () async {
                        await Future.delayed(Duration(seconds: 1));
                      },
                    ),
                    SizedBox(height: 20),
                    AnimateButton(
                      'animate button',
                      onClick: () async {
                        await Future.delayed(Duration(seconds: 5));
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
