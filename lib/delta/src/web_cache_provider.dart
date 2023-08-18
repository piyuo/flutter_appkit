import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// isCacheAllowed return true if cache is allowed
bool get isCacheAllowed =>
    !kIsWeb && (UniversalPlatform.isAndroid || UniversalPlatform.isIOS || UniversalPlatform.isMacOS);

/// _cacheManager is the cache manager
BaseCacheManager webCacheManager = CacheManager(
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

  /// disposed return true if disposed, use this to avoid notifyListeners after dispose
  bool disposed = false;

  /// getFileFromCache will download
  Future<File?> getFileFromCache(String url) async {
    if (isCacheAllowed) {
      try {
        FileInfo? fileInfo = await webCacheManager.getFileFromCache(url);
        fileInfo ??= await webCacheManager.downloadFile(url);
        return fileInfo.file;
      } catch (_) {}
    }
    hasError = true;
    return null;
  }

  @override
  void notifyListeners() {
    if (disposed) {
      return;
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}
