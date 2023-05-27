import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/testing/testing.dart' as testing;
import '../src/rich_editor.dart';
import '../src/rich_editor_provider.dart';
import '../src/image_editor.dart';
import '../src/image_editor_dialog.dart';

main() => base.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routesBuilder: () => {
        '/': (context, state, data) => const EditorExample(),
      },
    );

class EditorExample extends StatelessWidget {
  const EditorExample({Key? key}) : super(key: key);

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
              testing.ExampleButton(label: 'rich editor', builder: () => _richEditor()),
              testing.ExampleButton(label: 'image editor', builder: () => _imageEditor()),
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
              color: Theme.of(context).colorScheme.primaryContainer,
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

  Widget _imageEditor() {
    return ChangeNotifierProvider<ImageEditorProvider>(
        create: (context) => ImageEditorProvider(
              url:
                  'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-card-40-iphone13pink-202109?wid=340&hei=264&fmt=p-jpg&qlt=95&.v=1629948812000',
            ),
        child: Consumer<ImageEditorProvider>(builder: (context, provide, child) {
          return Column(children: [
            SizedBox(
                width: 400,
                height: 400,
                child: ImageEditor(
                  controller: provide,
                )),
            ElevatedButton(
                child: const Text('test crop'),
                onPressed: () async {
                  //final bytes = await provide.crop();
                  //provide.setBytes(bytes);
                }),
            ElevatedButton(
                child: const Text('image editor dialog'),
                onPressed: () async {
                  final bytes = await showImageEditor(
                    context,
                    url: 'https://www.apple.com/v/watch/ao/images/overview/series-7/hero_s7__ep2maoos292e_large.jpg',
                  );
                  if (bytes != null) {
                    provide.setBytes(bytes);
                  }
                }),
          ]);
        }));
  }
}
