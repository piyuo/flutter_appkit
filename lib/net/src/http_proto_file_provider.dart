import 'dart:async';
import 'package:flutter/widgets.dart' hide Builder;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/cache/cache.dart' as cache;
import 'protobuf.dart';
import 'object.dart';

/// HttpProtoFileProvider can download a protobuf file from remote service and convert it to object
/// ```dart
/// final httpProtoFiletProvider = HttpProtoFileProvider();
/// httpProtoFiletProvider.mockDownloader = (String url) async => pb.OK();
/// final obj = await httpProtoFiletProvider.download('https://piyuo.com/brand/index.pb');
/// ```
class HttpProtoFileProvider {
  /// mockDownloader is a test function, it can be overwrite to mock download object
  @visibleForTesting
  Future<Object> Function(String url)? mockDownloader;

  /// fileProvider to get object file
  final cache.HttpFileProvider fileProvider = cache.HttpFileProvider();

  /// of get SessionProvider from context
  static HttpProtoFileProvider of(BuildContext context) {
    return Provider.of<HttpProtoFileProvider>(context, listen: false);
  }

  /// download protobuf file from remote service and convert it to object
  /// it will cache the file in local storage or throw exception if it cannot get file
  /// ```dart
  /// download('https://piyuo.com/brand/index.pb');
  /// ```
  Future<T> download<T extends Object>(String url, Builder<T>? builder) async {
    // for test
    dynamic obj;
    if (!kReleaseMode && mockDownloader != null) {
      obj = await mockDownloader!(url);
    } else {
      final bytes = await fileProvider.getSingleFile(url);
      obj = decode(bytes, builder);
    }
    if (obj is T) {
      return obj;
    }
    throw AssertionError('object type is not match, expect ${T.toString()}, but get ${obj.runtimeType}' '');
  }
}
