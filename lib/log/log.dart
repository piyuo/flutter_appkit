import 'package:flutter/foundation.dart';
import 'package:libcli/app/app.dart' as app;
import 'package:libcli/tools/tools.dart' as tools;
import 'package:libcli/analytic/analytic.dart' as analytic;
import 'package:libcli/log/color.dart';

const _LEVEL_INFO = 1;
const _LEVEL_WARNING = 2;
const _LEVEL_ALERT = 3;

/// create log head, like application.identity.where:
///
///     String head = head();
String head(String where) {
  String text = '${app.piyuoid}/$where';
  if (app.identity != '') {
    text = app.identity + "@" + text;
  }
  return text + ": ";
}

/// print debug info to console
///
///     const HERE='current package';
///     log.debug(HERE,'hello');
void debug(String where, String message) {
  if (!kReleaseMode) {
    message = '$BLUE${head(where)}$RESET$message';
    print(message);
  }
}

/// print debug info to console
///
///     const HERE='current package';
///     log.debug(HERE,'hello');
void debugWarning(String where, String message) {
  debug(where, YELLOW + message);
}

/// print debug info to console
///
///     const HERE='current package';
///     log.debug(HERE,'hello');
void debugAlert(String where, String message) {
  debug(where, RED + message);
}

/// Normal but significant events, such as start up, shut down, or a configuration change.
///
///     const HERE='current package';
///     log.notice(HERE,'hello');
void info(String where, String message) {
  _log(where, message, _LEVEL_INFO);
}

/// Warning events might cause problems.
///
///     const HERE='current package';
///     log.warning(HERE,'hello');
void warning(String where, String message) {
  _log(where, message, _LEVEL_WARNING);
}

/// A person must take an action immediately
///
///     const HERE='current package';
///     log.alert(HERE,'hello');
void alert(String where, String message) {
  _log(where, message, _LEVEL_ALERT);
}

/// log to server with emergency level
///
///     const HERE='current package';
///     _log(HERE,'hello');
void _log(String where, String message, int level) {
  var fontColor = RESET;
  switch (level) {
    case 1:
      fontColor = CYAN;
      break;
    case 2:
      fontColor = YELLOW;
      break;
    case 3:
      fontColor = RED;
      break;
  }
  print('$BLUE${head(where)}$fontColor$message$MAGENTA (logged)');
  analytic.log(where, message, level);
}

/// record error to server
///
///     const HERE='current package';
///     try {
///       throw Exception('my error');
///     } catch (e, s) {
///       var errID = log.error(HERE, e, s);
///     }
String error(String where, e, s) {
  String errID = tools.uuid();
  String msg = e.toString().replaceAll('Exception: ', '');
  String stack = beautyStack(s);
  print('$BLUE${head(where)}$RED$msg $MAGENTA($errID)\n$YELLOW$stack');
  analytic.error(where, msg, stack, errID);
  return errID;
}

///beautyStack return simple format stack trace
///
///	catch (e, s) {
///	String text = log.beautyStack(s);
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
///	log.beautyLine(l);
String beautyLine(String l) {
  l = beautyLine2(l);
  return l.replaceAll('file:///Users/cc/Dropbox/prj/fl/', '');
}

String beautyLine2(String l) {
  l = l.replaceAll('<anonymous closure>', '').replaceAll(
      new RegExp(r"\s+\b|\b\s"),
      ' '); // convert spaces to _ for stack driver format

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
bool isLineUsable(String line) {
  List<String> containKeywords = [
    'asynchronous',
    '(dart:',
    'package:http/src/',
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
