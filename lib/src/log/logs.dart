List logs = [];

class Log {
  final String message;
  final String stacktrace;
  final DateTime when = DateTime.now();
  Log({
    required this.message,
    required this.stacktrace,
  });
}

/// pushLog push a log to logs, logs can keep max 50 logs.
///
void pushLog({
  required String message,
  String stacktrace = '',
  String states = '',
}) {
  logs.insert(
    0,
    Log(
      message: message,
      stacktrace: stacktrace,
    ),
  );
  if (logs.length > 50) {
    logs.removeLast();
  }
}

/// printLogs print all logs
///
String printLogs() {
  var buffer = StringBuffer();
  for (Log log in logs) {
    buffer.writeln('${log.when}: ${log.message}');
    if (log.stacktrace.isNotEmpty) {
      buffer.writeln(log.stacktrace);
    }
    buffer.writeln();
  }
  return buffer.toString();
}
