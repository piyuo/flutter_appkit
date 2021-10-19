import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:just_audio/just_audio.dart';

class AudioProvider with ChangeNotifier {
  AudioProvider();

  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  /// play play audio file from url
  ///
  ///      playURL('https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3');
  ///
  Future<void> playURL(String url) async {
    await _player.setUrl(url);
    _player.play();
  }

  /// playRemoteAsset play remote audio asset file from url, it will add default ext name with i18n locale
  ///
  ///      playURL('file-examples-com.github.io/asset/audio/file');
  ///
  Future<void> playRemoteAsset(String serverPath) async {
    await _player.setUrl('https://{serverPath}_${i18n.localeName}.mp4');
    _player.play();
  }

  /// playAsset play asset audio, it will add default path and ext name with i18n locale
  ///
  ///     playAsset('new_order');
  ///
  Future<void> playAsset(String assetName) async {
    await _player.setAsset('asset/audio/${assetName}_${i18n.localeName}.mp4');
    _player.play();
  }
}
