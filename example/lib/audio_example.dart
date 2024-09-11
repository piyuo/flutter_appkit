// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/apollo/apollo.dart' as apollo;
import 'package:libcli/audio/audio.dart';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/testing/testing.dart' as testing;
import 'package:provider/provider.dart';

main() => apollo.start(
      routes: {
        '/': (context, state, data) => const AudioExample(),
      },
    );

class AudioExample extends StatelessWidget {
  const AudioExample({super.key});

  @override
  Widget build(BuildContext context) {
    playAudio(_) {
      return ChangeNotifierProvider<AudioProvider>(
          create: (context) => AudioProvider(),
          child: Consumer<AudioProvider>(builder: (context, audioProvider, child) {
            return Column(children: [
              OutlinedButton(
                  child: const Text('play asset audio'),
                  onPressed: () async {
                    i18n.withLocale('en_US', () async {
                      await audioProvider.playAsset('new_order');
                    });
                  }),
              OutlinedButton(
                  child: const Text('play zh_TW audio'),
                  onPressed: () async {
                    i18n.withLocale('zh_TW', () async {
                      await audioProvider.playAsset('new_order');
                    });
                  }),
              OutlinedButton(
                  child: const Text('play online audio'),
                  onPressed: () async {
                    await audioProvider.playURL(
                        'https://file-examples.com/storage/fef44df12666d835ba71c24/2017/11/file_example_MP3_700KB.mp3');
                  })
            ]);
          }));
    }

    return testing.ExampleScaffold(
      builder: playAudio,
      buttons: [
        testing.ExampleButton('play audio', builder: playAudio),
      ],
    );
  }
}
