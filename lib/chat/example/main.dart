import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/base/base.dart' as base;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import '../chat.dart';

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
            ],
          ),
        ]),
      ),
    );
  }

  Widget _messageEditor() {
    return ChangeNotifierProvider<ChatBarProvider>(
      create: (context) => ChatBarProvider(),
      child: Consumer<ChatBarProvider>(builder: (context, messageEditorProvider, child) {
        return Column(children: [
          const Spacer(),
          ChatBar(
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
                  return SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: MessageView(
                            textStyle: const TextStyle(color: Colors.red, fontSize: 16),
                            messageViewProvider: messageViewProvider,
                            words: words,
                          )));
                }))));
  }
}
