import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/pb/pb.dart' as pb;
import 'protobuf.dart';

/// Downloader can download a protobuf file from remote service and return object
class Downloader {
  Downloader({
    this.timeout = const Duration(milliseconds: 20000),
    this.fileGetter = getFile,
  });

  /// timeout define request timeout in ms
  final Duration timeout;

  final Future<Uint8List?> Function(String url, Duration timeout) fileGetter;

  /// download protobuf file from remote service and return object
  /// ```dart
  /// download('https://piyuo.com/brand/index.pb');
  /// ```
  Future<pb.Object?> download(String url, pb.Builder? builder) async {
    final bytes = await fileGetter(url, timeout);
    if (bytes != null) {
      return decode(bytes, builder);
    }
    return null;
  }
}

Future<Uint8List?> getFile(String url, Duration timeout) async {
  http.Client client = http.Client();
  var resp = await client.post(
    Uri.parse(url),
    headers: {'Content-Type': 'multipart/form-data'},
  ).timeout(timeout);

  if (resp.statusCode == 200) {
    return resp.bodyBytes;
  }
  return null;
}
