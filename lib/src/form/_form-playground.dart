import 'package:flutter/material.dart';
import 'package:libcli/types.dart' as types;
import 'input-field.dart';
import 'email-field.dart';
import 'submit.dart';
import 'animate-button.dart';
import 'check.dart';
import 'dropdown-field.dart';
import 'tags.dart';
import 'click-field.dart';

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

  final checkController = types.BoolController();

  final emailController = TextEditingController();

  final emailFocusNode = FocusNode();

  final _keyForm = GlobalKey<FormState>();

  FormPlayground() {
//    clickController.text = 'click text';
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: textController,
                  label: 'input field label',
                  hint: 'please input text',
                  require: 'input is required',
                ),
                br(),
                DropdownField(
                  controller: dropdownController,
                  items: dropdownItems,
                  label: 'dropdown field label',
                  require: 'you must select 1 item',
                ),
                p(),
                ClickField(
                  controller: clickController,
                  label: 'click field label',
                  onClicked: (String text) async {
                    return "hello";
                  },
                  require: 'you must click to set value',
                ),
                br(),
                EmailField(
                  controller: emailController,
                  label: 'email field',
                  focusNode: emailFocusNode,
                ),
                SizedBox(height: 20),
                Check(
                  controller: checkController,
                  label: 'my check',
                ),
                SizedBox(height: 20),
                Submit(
                  'Submit form',
                  form: _keyForm,
                  onClick: () async {
                    //await Future.delayed(Duration(seconds: 1));
                  },
                ),
                SizedBox(height: 20),
                SizedBox(height: 20),
                Submit(
                  'Submit long waiting form',
                  onClick: () async {
                    await Future.delayed(Duration(seconds: 5));
                    return true;
                  },
                ),
                SizedBox(height: 20),
                Submit(
                  'Select',
                  sizeLevel: 0.8,
                  onClick: () async {
                    await Future.delayed(Duration(seconds: 1));
                  },
                ),
                AnimateButton(
                  'animate button',
                  onClick: () async {
                    await Future.delayed(Duration(seconds: 5));
                    return true;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
