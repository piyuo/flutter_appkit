import 'package:flutter/material.dart';
import 'form.dart' as form;
import 'package:libcli/src/widgets/widgets.dart' as widgets;

class Playground extends StatelessWidget {
  final GlobalKey btnMenu = GlobalKey();

  final GlobalKey btnTooltip = GlobalKey();

  final checkController = widgets.BoolEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              form.TextEdit(
                controller: textController,
                label: 'my text field',
              ),
              form.p(),
              form.EmailEdit(
                controller: emailController,
                suggestLabel: 'suggest',
                label: 'my email field',
              ),
              form.br(),
              form.Dropdown(
                controller: dropdownController,
                items: dropdownItems,
                label: 'my dropdown',
              ),
              SizedBox(height: 20),
              form.Check(
                controller: checkController,
                label: 'my check',
              ),
              SizedBox(height: 20),
              form.AnimateButton(
                'Submit form',
                onClick: () async {
                  await Future.delayed(Duration(seconds: 3));
                  return true;
                },
              ),
              SizedBox(height: 20),
              form.Submit(
                'Submit form',
                onClick: () async {
                  await Future.delayed(Duration(seconds: 3));
                },
              ),
              SizedBox(height: 20),
              form.Submit(
                'Select',
                sizeLevel: 0.8,
                onClick: () async {
                  await Future.delayed(Duration(seconds: 3));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
