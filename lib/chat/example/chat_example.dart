import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/testing/testing.dart' as testing;
import '../chat.dart';

main() => apollo.start(
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
    Widget chatBar() {
      return ChangeNotifierProvider<ChatBarProvider>(
        create: (context) => ChatBarProvider(),
        child: Consumer<ChatBarProvider>(builder: (context, messageEditorProvider, child) {
          return Column(children: [
            const Spacer(),
            ChatBar(
              chatBarProvider: messageEditorProvider,
              onSend: (context, words, map) async {
                await Future.delayed(const Duration(milliseconds: 800));
                debugPrint('onSend: ${map.length}');
                return true;
              },
            ),
          ]);
        }),
      );
    }

    Widget singleVideo() {
      final words = [
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_VIDEO,
          value: 'video1',
          width: 1926,
          height: 1080,
        ),
      ];

      return Align(
          alignment: Alignment.centerLeft,
          child: Container(
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: MessageView(
                urlBuilder: (id) {
                  return 'https://download.samplelib.com/mp4/sample-5s.mp4';
                },
                words: words,
              )));
    }

    Widget singleImage() {
      final words = [
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_IMAGE,
          value: 'img1',
          width: 4000,
          height: 6000,
        ),
      ];

      return Align(
          alignment: Alignment.centerLeft,
          child: Container(
              margin: const EdgeInsets.all(10),
              color: Colors.blue,
              child: MessageView(
                textStyle: const TextStyle(color: Colors.red, fontSize: 16),
                urlBuilder: (id) {
                  return 'https://images.pexels.com/photos/13766623/pexels-photo-13766623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
                },
                words: words,
              )));
    }

    Widget messageView() {
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
          width: 1920,
          height: 1080,
        ),
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_TEXT,
          value: 'hello',
        ),
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_TEXT,
          value: ' world',
        ),
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_IMAGE,
          value: 'img1',
          width: 4000,
          height: 6000,
        ),
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_VIDEO,
          value: 'video1',
          width: 1920,
          height: 1080,
        ),
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_TEXT,
          value: 'Regards,\nMy name',
        ),
      ];

      final words2 = [
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_IMAGE,
          value: 'img1',
          width: 4000,
          height: 6000,
        ),
      ];

      final words3 = [
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_TEXT,
          value: 'Regards,\nMy name',
        ),
        pb.Word(
          type: pb.Word_WordType.WORD_TYPE_IMAGE,
          value: 'img1',
          width: 4000,
          height: 6000,
        ),
      ];

      return SingleChildScrollView(
          child: Column(children: [
        Container(
            margin: const EdgeInsets.all(10),
            color: Colors.red,
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: MessageView(
                      urlBuilder: (id) {
                        if (id == 'video1') {
                          return 'https://download.samplelib.com/mp4/sample-5s.mp4';
                        }
                        return 'https://images.pexels.com/photos/13766623/pexels-photo-13766623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
                      },
                      words: words3,
                    )))),
        Container(
            margin: const EdgeInsets.all(10),
            color: Colors.blue,
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: MessageView(
                      urlBuilder: (id) {
                        if (id == 'video1') {
                          return 'https://download.samplelib.com/mp4/sample-5s.mp4';
                        }
                        return 'https://images.pexels.com/photos/13766623/pexels-photo-13766623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
                      },
                      textStyle: const TextStyle(color: Colors.red, fontSize: 16),
                      words: words,
                    )))),
        Container(
            margin: const EdgeInsets.all(10),
            color: Colors.green,
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: MessageView(
                      urlBuilder: (id) {
                        if (id == 'video1') {
                          return 'https://download.samplelib.com/mp4/sample-5s.mp4';
                        }
                        return 'https://images.pexels.com/photos/13766623/pexels-photo-13766623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
                      },
                      words: words2,
                    ))))
      ]));
    }

    return testing.ExampleScaffold(
      builder: chatBar,
      buttons: [
        testing.ExampleButton('single video', builder: singleVideo),
        testing.ExampleButton('single image', builder: singleImage),
        testing.ExampleButton('message view', builder: messageView),
        testing.ExampleButton('chatBar', builder: chatBar),
      ],
    );
  }
}
