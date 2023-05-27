import 'dart:async';

class DelayedRun {
  final Duration duration;

  Timer? timer;

  DelayedRun({
    this.duration = const Duration(milliseconds: 850),
  });

  void run(void Function() callback) {
    cancel();
    timer = Timer(duration, callback);
  }

  void cancel() {
    if (timer != null) {
      timer!.cancel();
    }
  }
}
