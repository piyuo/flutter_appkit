// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/custom.dart' as custom;
import 'package:libcli/delta.dart' as delta;
import 'rich_editor.dart';
import 'rich_editor_provider.dart';

class EditorPlayground extends StatelessWidget {
  const EditorPlayground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                child: _richEditor(),
              ),
              custom.example(
                context,
                text: 'rich editor',
                child: _richEditor(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _richEditor() {
    return ChangeNotifierProvider<RichEditorProvider>(
      create: (context) => RichEditorProvider(),
      child: Consumer<RichEditorProvider>(builder: (context, provide, child) {
        return Container(
            padding: const EdgeInsets.all(3.0),
            margin: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              color: context.themeColor(light: Colors.white, dark: Colors.grey[800]!),
            ),
            child: Column(children: [
              RichEditor(
                controller: provide,
              ),
              ElevatedButton(
                  child: const Text('to plain text'),
                  onPressed: () {
                    debugPrint(provide.toJSON());
                  }),
            ]));
      }),
    );
  }
}
