List logs = [];

class Log {
  final String message;
  final String stacktrace;
  final String states;
  final DateTime when = DateTime.now();
  Log({
    required this.message,
    required this.stacktrace,
    required this.states,
  });
}

/// addLog log to logs, logs can keep max 20 logs.
///
void addLog({
  required String message,
  int level = 1,
  String stacktrace = '',
  String states = '',
}) {
  logs.add(Log(
    message: message,
    stacktrace: stacktrace,
    states: states,
  ));
  if (logs.length > 100) {
    logs.removeAt(0);
  }
}
