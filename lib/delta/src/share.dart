import 'package:share_plus/share_plus.dart';
import 'web_cache_provider.dart';

/// shareByCacheOrUrl share image by cache or url
Future<void> shareByCacheOrUrl(String url) async {
  // android/ios image must have cache
  final fileInfo = await webCacheManager.getFileFromCache(url);
  if (fileInfo != null) {
    final xFile = XFile(fileInfo.file.path);
    Share.shareXFiles([xFile]);
    return;
  }
  // file not support share, use url
  Share.share(url);
}
