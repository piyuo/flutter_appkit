import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:libcli/src/log/logs.dart';
import 'package:libcli/app.dart' as configuration;

const _b = '\u001b[';
const COLOR_END = _b + '0m';
const COLOR_RED = _b + '31m';
const COLOR_GREEN = _b + '32m';
const COLOR_YELLOW = _b + '33m';
const COLOR_BLUE = _b + '34m';
const COLOR_MAGENTA = _b + '35m';
const COLOR_CYAN = _b + '36m';

const COLOR_ALERT = COLOR_END;
const COLOR_WARNING = COLOR_YELLOW;
const COLOR_MEMORY = COLOR_MAGENTA;
const COLOR_NETWORK = COLOR_CYAN;
const COLOR_STATE = COLOR_GREEN;

/// reduxStates keep all redux states
///
final List<Map> reduxStates = [];

/// reduxNewState keep newStat in from(), it will be null when merage to state
///
Map? reduxNewState = null;

/// safeJsonEncode return json of object, return object.toString() if can't encode json
///
///
String safeJsonEncode(Object object) {
  try {
    return jsonEncode(object);
  } catch (e) {
    debugPrint(e.toString());
  }
  return toLogString(object);
}

/// readReduxStates print all redux states to string
///
///
String readReduxStates() {
  var buffer = new StringBuffer();
  buffer.write('[');
  for (var i = 0; i < reduxStates.length; i++) {
    var str = safeJsonEncode(reduxStates[i]);
    buffer.write(str);
    if (i < reduxStates.length - 1) {
      buffer.write(',');
    }
  }
  if (reduxNewState != null) {
    buffer.write(',');
    var str = safeJsonEncode(reduxNewState!);
    buffer.write(str);
  }

  buffer.write(']');
  return buffer.toString();
}

/// log normal but significant events, such as start up, shut down, or a configuration change.
///
///     log('something done');
///
void log(String message) {
//  if (!kReleaseMode) {}
  debugPrint('$COLOR_BLUE$header$COLOR_END $message');
  addLog(message: message);
}

/// error print error message to console and keep log
///
///     try {
///       throw Exception('my error');
///     } catch (e, s) {
///       error( e, s);
///     }
///
void error(dynamic e, StackTrace stacktrace) {
  String message = '';
  try {
    message = e.toString().replaceAll('Exception: ', '');
  } catch (_) {
    message = e.runtimeType.toString();
  }
  String states = readReduxStates();
  String stack = beautyStack(stacktrace);
  debugPrint('$COLOR_BLUE$header$COLOR_END ${COLOR_ALERT}caught $message\n$stack\n$states');
  addLog(
    message: message,
    stacktrace: stack,
    states: states,
  );
}

/// header return  user@application:
///
///     print(header); // 'kevin@piyuo: hello world'
///
@visibleForTesting
String get header {
  return '${configuration.userID}@${configuration.appID}:';
}

///beautyStack return simple format stack trace
///
///	catch (e, s) {
///	String text = beautyStack(s);
///	expect(text.length > 0, true);
///	}
String beautyStack(StackTrace stack) {
  final buffer = StringBuffer();
  List<String> lines = stack.toString().split('\n');
  for (var l in lines) {
    if (isLineUsable(l) && l.length > 6) {
      l = beautyLine(l);
      if (l != '') {
        buffer.writeln(l);
      }
    }
  }

  var result = buffer.toString();
  if (buffer.length > 0) {
    result = result.substring(0, buffer.length - 1);
  }
  return result;
}

///beautyLine return line that accept by google stack driver format
///
///	beautyLine(l);
@visibleForTesting
String beautyLine(String l) {
  return _beautyLine(l).replaceAll('file:///Users/cc/Dropbox/prj/fl/', '');
}

String _beautyLine(String l) {
  l = l
      .replaceAll('<anonymous closure>', '')
      .replaceAll(new RegExp(r"\s+\b|\b\s"), ' '); // convert spaces to _ for stack driver format

  if (l.startsWith('#')) {
    var i = l.indexOf(' ');
    return 'at ' + l.substring(i, l.length).trim();
  }
  var list = l.split('.dart');
  if (list.length == 2) {
    var file = list[0].trim().replaceAll(' ', '_') + '.dart';
    var pos = list[1].trim().replaceAll(' ', '_');
    return 'at $file ($pos)';
  }
  return '';
}

/// isLineUsable check line to see if we need it for debug
///
///	line := "/convey/doc.go:75"
///	So(isLineUsable(line), ShouldBeFalse)
@visibleForTesting
bool isLineUsable(String line) {
  List<String> containKeywords = [
    'asynchronous',
    '(dart:',
    'package:http/src/',
    'package:flutter/',
    'test_api',
    'flutter_test',
    'StackZone'
  ];
  for (var keyword in containKeywords) {
    if (line.contains(keyword)) {
      return false;
    }
  }
  List<String> startwithKeywords = [
    'package:stack_trace',
    'package:stream_channel',
    'dart:',
  ];
  for (var keyword in startwithKeywords) {
    if (line.startsWith(keyword)) {
      return false;
    }
  }

  return true;
}

/// toLogString encode object into string
///
///     toLogString(state);
///
String toLogString(dynamic value) {
  if (value != null) {
    var text = value.toString().replaceAll('\n', '');
    if (text.indexOf('Instance of') == -1) {
      return text;
    }
  }
  return '';
}
