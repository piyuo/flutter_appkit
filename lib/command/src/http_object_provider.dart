import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'protobuf.dart';

/// HttpObjectProvider can download a protobuf file from remote service and convert it to object
/// ```dart
/// final httpObjectProvider = HttpObjectProvider(mockObject: (String url) async => pb.OK());
/// final obj = await httpObjectProvider.download('https://piyuo.com/brand/index.pb');
/// ```
class HttpObjectProvider {
  HttpObjectProvider({this.mockObjectBuilder});

  /// objectGetter is a test function, it can be overwrite to mock get object
  final Future<pb.Object> Function(String url)? mockObjectBuilder;

  /// fileProvider to get object file
  final cache.HttpFileProvider fileProvider = cache.HttpFileProvider();

  /// of get SessionProvider from context
  static HttpObjectProvider of(BuildContext context) {
    return Provider.of<HttpObjectProvider>(context, listen: false);
  }

  /// download protobuf file from remote service and convert it to object
  /// it will cache the file in local storage or throw exception if it cannot get file
  /// ```dart
  /// download('https://piyuo.com/brand/index.pb');
  /// ```
  Future<T> download<T extends pb.Object>(String url, pb.Builder<T>? builder) async {
    // for test
    dynamic obj;
    if (!kReleaseMode && mockObjectBuilder != null) {
      obj = await mockObjectBuilder!(url);
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
