import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

const _kTimeout = Duration(milliseconds: 20000);

class FileProvider {
  FileProvider({this.fileGetter});

  /// fileGetter is a function to get file, it can be overwrite to mock get file
  final Future<Uint8List> Function(String url)? fileGetter;

  /// put the value, this is a FIFO cache, set the same key will make that key the latest key in [_cache]. the default expire duration is 5 minutes
  Future<Uint8List> getSingleFile(String url) async {
    if (fileGetter != null) {
      return await fileGetter!(url);
    }
    if (kIsWeb) {
      return await _getHttpFile(url, _kTimeout);
    }
    var file = await DefaultCacheManager().getSingleFile(url);
    return file.readAsBytes();
  }

  /// getFile is a default fileGetter, use http to get file, return null if cannot get file
  Future<Uint8List> _getHttpFile(String url, Duration timeout) async {
    http.Client client = http.Client();
    var resp = await client.get(Uri.parse(url)).timeout(_kTimeout);
    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    }
    throw Exception('cannot get file from $url');
  }
}
