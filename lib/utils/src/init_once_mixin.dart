/// InitOnceMixin is a mixin that make sure init only once
mixin InitOnceMixin {
  /// initialized is true if already init
  bool initialized = false;

  Future<void> Function()? initFuture;

  /// init start initFuture
  Future<void> init() async {
    if (initialized) {
      return;
    }
    await initFuture?.call();
    initialized = true;
  }
}
