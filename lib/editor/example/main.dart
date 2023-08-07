import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import '../editor.dart';

main() => base.start(
      theme: testing.theme(),
      darkTheme: testing.darkTheme(),
      routesBuilder: () => {
        '/': (context, state, data) => const EditorExample(),
      },
    );

class EditorExample extends StatelessWidget {
  const EditorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Expanded(
              child: Container(
            child: _messageView(),
          )),
          Wrap(
            children: [
              testing.ExampleButton(label: 'message view', builder: () => _messageView()),
              testing.ExampleButton(label: 'message editor', builder: () => _messageEditor()),
              testing.ExampleButton(label: 'rich editor', builder: () => _richEditor()),
              testing.ExampleButton(label: 'image editor', builder: () => _imageEditor()),
            ],
          ),
        ]),
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

  Widget _messageEditor() {
    return ChangeNotifierProvider<MessageEditorProvider>(
      create: (context) => MessageEditorProvider(),
      child: Consumer<MessageEditorProvider>(builder: (context, messageEditorProvider, child) {
        return Column(children: [
          const Spacer(),
          MessageEditor(
            messageEditorProvider: messageEditorProvider,
            onSend: (words, map) async {
              debugPrint('onSend: ${words.length}');
            },
          ),
        ]);
      }),
    );
  }

  Widget _messageView() {
    final words = [
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_TEXT,
        value: 'hi',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_EMOJI,
        value: '😀',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_TEXT,
        value: 'Everyone',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_VIDEO,
        value: 'video1',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_TEXT,
        value: 'hello',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_VIDEO,
        value: 'video1',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_TEXT,
        value: ' world',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_IMAGE,
        value: 'img1',
      ),
      pb.Word(
        type: pb.Word_WordType.WORD_TYPE_TEXT,
        value: 'Regards,\nMy name',
      ),
    ];

    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            //padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            color: Colors.blue,
            child: ChangeNotifierProvider<MessageViewProvider>(
                create: (context) => MessageViewProvider(
                      urlBuilder: (type, id) {
                        if (id == 'video1') {
                          return 'https://download.samplelib.com/mp4/sample-5s.mp4';
                        }
                        return 'https://images.pexels.com/photos/13766623/pexels-photo-13766623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
                      },
                    )..scanVideo(words),
                child: Consumer<MessageViewProvider>(builder: (context, messageViewProvider, child) {
                  // return Container(width: 100, height: 100);
                  return MessageView(
                    imageConstraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
                    textStyle: const TextStyle(color: Colors.red, fontSize: 16),
                    messageViewProvider: messageViewProvider,
                    words: words,
                  );
                }))));
  }
}
