import 'dart:ui';
import 'package:share_plus/share_plus.dart';
import 'web_cache_provider.dart';

/// shareByCacheOrUrl share image by cache or url
/// sharePositionOrigin is for ipad issue fix, see https://pub.dev/packages/share_plus
Future<void> shareByCacheOrUrl(String url, {Rect? sharePositionOrigin}) async {
  // android/ios image must have cache
  final fileInfo = await webCacheManager.getFileFromCache(url);
  if (fileInfo != null) {
    final xFile = XFile(fileInfo.file.path);
    Share.shareXFiles([xFile], sharePositionOrigin: sharePositionOrigin);
    return;
  }
  // file not support share, use url
  Share.share(url, sharePositionOrigin: sharePositionOrigin);
}
