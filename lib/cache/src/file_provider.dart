import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:libcli/general/general.dart' as general;

/// FileProvider is a class to get file, it can be overwrite to mock get file
/// it wall manage the cache for web and app
/// the default timeout to get file is 30s
class FileProvider {
  FileProvider({this.fileGetter});

  /// fileGetter is a function to get file, it can be overwrite to mock get file
  final Future<Uint8List> Function(String url)? fileGetter;

  /// put the value, this is a FIFO cache, set the same key will make that key the latest key in [_cache]. the default expire duration is 5 minutes
  Future<Uint8List> getSingleFile(String url) async {
    // for test
    if (fileGetter != null) {
      return await fileGetter!(url);
    }

    // for web, no need to cache, browser will cache it
    if (kIsWeb) {
      return await _getHttpFile(url);
    }

    // app mode, file cache clean by cache manager
    /*
    When are cached files removed?
    The files can be removed by the cache manager or by the operating system. By default the files are stored in a cache folder, which is sometimes cleaned for example on Android with an app update.
    The cache manager uses 2 variables to determine when to delete a file, the maxNrOfCacheObjects and the stalePeriod. The cache knows when files have been used latest. When cleaning the cache (which happens continuously), the cache deletes files when there are too many, ordered by last use, and when files just haven't been used for longer than the stale period.
     */
    var file = await DefaultCacheManager().getSingleFile(url);
    return file.readAsBytes();
  }

  /// getFile is a default fileGetter, use http to get file, return null if cannot get file
  Future<Uint8List> _getHttpFile(String url) async {
    http.Client client = http.Client();
    var resp = await client.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      return resp.bodyBytes;
    }
    throw general.TryAgainLaterException('cannot get file from $url');
  }
}
