// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:libcli/testing/testing.dart' as testing;
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:libcli/app/app.dart' as app;
import 'package:provider/provider.dart';
import '../src/audio.dart';

main() => app.start(
      appName: 'audio example',
      l10nDelegate: testing.MockLocalizationDelegate(),
      routes: (_) => const AudioExample(),
    );

class AudioExample extends StatelessWidget {
  const AudioExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Wrap(
            children: [
              Container(
                child: _playAudio(),
              ),
              testing.example(
                context,
                text: 'play audio',
                child: _playAudio(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _playAudio() {
    return ChangeNotifierProvider<AudioProvider>(
        create: (context) => AudioProvider(),
        child: Consumer<AudioProvider>(builder: (context, audioProvider, child) {
          return Column(children: [
            OutlinedButton(
                child: const Text('play asset audio'),
                onPressed: () async {
                  await audioProvider.playAsset('new_order');
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
                  await audioProvider
                      .playURL('https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3');
                })
          ]);
        }));
  }
}
