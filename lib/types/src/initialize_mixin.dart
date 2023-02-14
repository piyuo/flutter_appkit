/// InitializeMixin is a mixin that mean class need init() before use
mixin InitializeMixin {
  /// isReady is true if ready to use
  bool isReady = false;

  Future<void> Function()? initFuture;

  /// init start initFuture
  Future<void> init() async {
    if (isReady) {
      return;
    }
    await initFuture?.call();
    isReady = true;
  }
}
