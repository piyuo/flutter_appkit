import 'dart:async';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/cache/cache.dart' as cache;
import 'protobuf.dart';

/// Downloader can download a protobuf file from remote service and return object
/// ```dart
/// final downloader = Downloader();
/// final obj = await downloader.download('https://piyuo.com/brand/index.pb');
/// ```
class Downloader {
  Downloader({this.fileProvider});

  /// fileGetter is a function that get file from remote service, return null if cannot get file
  final cache.FileProvider? fileProvider;

  /// getObject download protobuf file from remote service and return object
  /// it will cache the file in local storage or throw exception if cannot get file
  /// ```dart
  /// getObject('https://piyuo.com/brand/index.pb');
  /// ```
  Future<T> getObject<T extends pb.Object>(String url, pb.Builder<T>? builder) async {
    final fileProvider = this.fileProvider ?? cache.FileProvider();
    final bytes = await fileProvider.getSingleFile(url);
    return decode(bytes, builder) as T;
  }
}
