import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// isCacheAllowed return true if cache is allowed
bool get isCacheAllowed =>
    !kIsWeb && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isMacOS);

/// _cacheManager is the cache manager
BaseCacheManager _cacheManager = CacheManager(
  Config(
    'webCache',
    stalePeriod: const Duration(days: 360),
    maxNrOfCacheObjects: 1000,
  ),
);

/// WebCacheProvider provide cache manager for android/ios/mac platform
class WebCacheProvider with ChangeNotifier {
  /// hasError return true if video has error
  bool hasError = false;

  /// getFileFromCache will download
  Future<File?> getFileFromCache(String url) async {
    if (isCacheAllowed) {
      try {
        FileInfo? fileInfo = await _cacheManager.getFileFromCache(url);
        fileInfo ??= await _cacheManager.downloadFile(url);
        return fileInfo.file;
      } catch (_) {}
    }
    hasError = true;
    return null;
  }
}
