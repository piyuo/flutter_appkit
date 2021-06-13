import 'package:flutter/material.dart';
import 'package:libcli/ui.dart' as ui;
import 'package:libcli/types.dart' as types;
import 'text-edit.dart';
import 'email-edit.dart';
import 'submit.dart';
import 'animate-button.dart';
import 'check.dart';
import 'dropdown.dart';
import 'tags.dart';

class FormPlayground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();

  final GlobalKey btnTooltip = GlobalKey();

  final checkController = types.BoolController();

  final dropdownController = TextEditingController();

  final emailController = TextEditingController();

  final textController = TextEditingController();

  final Map dropdownItems = {
    "": "",
    "a": "1",
    "b": "2",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextEdit(
                controller: textController,
                label: 'my text field',
              ),
              p(),
              EmailEdit(
                controller: emailController,
                suggestLabel: 'suggest',
                label: 'my email field',
              ),
              br(),
              Dropdown(
                controller: dropdownController,
                items: dropdownItems,
                label: 'my dropdown',
              ),
              SizedBox(height: 20),
              Check(
                controller: checkController,
                label: 'my check',
              ),
              SizedBox(height: 20),
              AnimateButton(
                'animate button',
                onClick: () async {
                  await Future.delayed(Duration(seconds: 5));
                  return true;
                },
              ),
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
                'Submit form',
                onClick: () async {
                  await Future.delayed(Duration(seconds: 1));
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
            ],
          ),
        ),
      ),
    );
  }
}
