import 'dart:async';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/cache/cache.dart' as cache;
import 'package:libcli/net/net.dart' as net;

/// Downloader can download a protobuf file from remote service and convert it to object
/// ```dart
/// final downloader = Downloader();
/// downloader.mock = (String url) async => pb.OK();
/// final obj = await downloader.download('https://piyuo.com/brand/index.pb');
/// ```
class Downloader {
  /// mock is a test function, it can be overwrite to mock download object
  @visibleForTesting
  Future<Object> Function(String url)? mock;

  /// fileProvider to get object file
  final cache.HttpFileProvider fileProvider = cache.HttpFileProvider();

  /// of get SessionProvider from context
  static Downloader of(BuildContext context) {
    return Provider.of<Downloader>(context, listen: false);
  }

  /// download protobuf file from remote service and convert it to object
  /// it will cache the file in local storage or throw exception if it cannot get file
  /// ```dart
  /// download('https://piyuo.com/brand/index.pb');
  /// ```
  Future<T> download<T extends Object>(String url, net.Builder<T>? builder) async {
    // for test
    dynamic obj;
    if (!kReleaseMode && mock != null) {
      obj = await mock!(url);
    } else {
      final bytes = await fileProvider.getSingleFile(url);
      obj = net.decode(bytes, builder);
    }
    if (obj is T) {
      return obj;
    }
    throw AssertionError('object type is not match, expect ${T.toString()}, but get ${obj.runtimeType}' '');
  }
}
