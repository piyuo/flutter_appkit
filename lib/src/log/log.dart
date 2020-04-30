import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:libcli/src/log/analytic.dart' as analytic;
import 'package:libcli/configuration.dart' as configuration;

const LEVEL_INFO = 1;
const LEVEL_WARNING = 2;
const LEVEL_ALERT = 3;
const _b = '\u001b[';
const RESET = _b + '0m';
const RED = _b + '31m';
const GREEN = _b + '32m';
const YELLOW = _b + '33m';
const BLUE = _b + '34m';
const MAGENTA = _b + '35m';
const CYAN = _b + '36m';

const HEAD = BLUE;
const END = RESET;

const WARNING = YELLOW;
const ALERT = RED;
const ALLOCATION = MAGENTA;
const NETWORK = CYAN;
const STATE = GREEN;

/// overrideDebugPrint override debugPrint()
///
///     debugPrint = overrideDebugPrint;
///
void overrideDebugPrint(String message, {int wrapWidth}) {
  if (!kReleaseMode) {
    int pos = message.indexOf('~');
    var h = '';
    var m = '';
    if (pos != -1) {
      h = head(message.substring(0, pos));
      m = message.substring(pos + 1, message.length);
    } else {
      h = head('');
      m = message;
    }
    message = '$HEAD$h$END$m';
/*
    if (Platform.isIOS) {
      print(message
          .replaceAll(HEAD, '')
          .replaceAll(HEAD, '')
          .replaceAll(VERB, '')
          .replaceAll(NOUN, '')
          .replaceAll(NOUN2, '')
          .replaceAll(END, '')
          .replaceAll(WARNING, '')
          .replaceAll(ALERT, ''));
      return;
    }*/
    print(message);
  }
}

/// log print message and log to analytic
///
///      _log(this, logger.LEVEL_INFO, '');
void _log(String message, int level, String hint) {
  assert(message.length > 0);
  assert(message.indexOf('~') != -1, 'must begin with "where~"');
  int pos = message.indexOf('~');
  var h = '';
  var m = '';
  if (pos != -1) {
    h = head(message.substring(0, pos));
    m = message.substring(pos + 1, message.length);
  } else {
    h = head('');
    m = message;
  }
  debugPrint('$message (logged)');
  analytic.saveLog(h, m, level);
}

/// log normal but significant events, such as start up, shut down, or a configuration change.
///
///     log('here~something ${VERB} done');
void log(String message) {
  _log(message, LEVEL_INFO, '');
}

/// warning events might cause problems.
///
///     warning('here~things need to ${VERB}watch');
void warning(String message) {
  _log(message, LEVEL_WARNING, '${WARNING}[!WARNING] $END');
}

/// alert a person must take an action immediately
///
///     alert('here~something${VERB} go ${NOUN}wrong');
void alert(String message) {
  _log(message, LEVEL_ALERT, '${ALERT}[!!ALERT]  $END');
}

/// error handling
///
///     const HERE='current package';
///     try {
///       throw Exception('my error');
///     } catch (e, s) {
///       var errID = error(HERE, e, s);
///     }
void error(String where, dynamic e, StackTrace stacktrace) {
  String msg = e.toString().replaceAll('Exception: ', '');
  String stack = beautyStack(stacktrace);
  debugPrint('$where~${ALERT}caught $msg\n$stack');
  analytic.saveError(where, msg, stack);
}

/// create log head, like application.identity.where:
///
///     String head = head();
@visibleForTesting
String head(String where) {
  String text = '${configuration.appID}/$where';
  if (configuration.userID != '') {
    text = configuration.userID + "@" + text;
  }
  return text + ": ";
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

/// toString encode object to string
///
///     toString(state);
///
String toString(dynamic value) {
  if (value != null) {
    var text = value.toString().replaceAll('\n', '');
    if (text.indexOf('Instance of') == -1) {
      return text;
    }
  }
  return '';
}
