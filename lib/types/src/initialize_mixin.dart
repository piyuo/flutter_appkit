/// InitializeMixin is a mixin that mean class need init() before use
mixin InitializeMixin {
  /// isReady is true if ready to use
  bool isReady = false;

  Future<void> Function()? initFuture;

  /// init stores by brand id
  Future<void> init() async {
    if (isReady) {
      return;
    }
    initFuture?.call();
    isReady = true;
  }
}
