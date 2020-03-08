import 'package:flutter/foundation.dart';
import 'package:libcli/analytic/analytic.dart' as analytic;
import 'package:libcli/tools/id.dart' as id;
import 'package:libcli/env/env.dart';

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
const VERB = MAGENTA;
const NOUN = GREEN;
const NOUN2 = YELLOW;
const END = RESET;
const WARNING = YELLOW;
const ALERT = RED;

printToConsole(String message) {
  print(message);
}

///LogExtension will allow you to add `.print`,`.log`,`.warning`,`.alert`,`.error` to your strings
///
extension LogExtension on String {
  /// print debug info to console
  ///
  ///     'here|Job ${VERB}done'.print;
  get print {
    if (!kReleaseMode) {
      assert(this.length > 0);
      assert(this.indexOf('|') != -1, 'must begin with "where|"');
      List<String> args = this.split('|');
      assert(args.length == 2);
      var h = head(args[0]);
      var m = args[1];
      printToConsole('$HEAD${h}$END/$m');
    }
  }

  /// log print message and log to analytic
  ///
  ///      _log(this, logger.LEVEL_INFO, '');
  _log(String message, int level, String hint) {
    assert(message.length > 0);
    assert(message.indexOf('|') != -1, 'must begin with "where|"');
    List<String> args = message.split('|');
    assert(args.length == 2);
    var h = head(args[0]);
    var m = args[1];
    printToConsole('$HEAD$h$END/$hint$m$END (logged)');
    analytic.log(args[0], args[1], level);
  }

  /// log normal but significant events, such as start up, shut down, or a configuration change.
  ///
  ///     'here|something ${VERB} done'.log;
  get log {
    _log(this, LEVEL_INFO, '');
  }

  /// warning events might cause problems.
  ///
  ///     'here|things need to ${VERB}watch'.warning;
  get warning {
    _log(this, LEVEL_WARNING, '${WARNING}[!WARNING] $END');
  }

  /// alert a person must take an action immediately
  ///
  ///     'here|something${VERB} go ${NOUN}wrong'.alert;
  get alert {
    _log(this, LEVEL_ALERT, '${ALERT}[!!ALERT]  $END');
  }

  /// error handling
  ///
  ///     const HERE='current package';
  ///     try {
  ///       throw Exception('my error');
  ///     } catch (e, s) {
  ///       var errID = error(HERE, e, s);
  ///     }
  String error(dynamic e, StackTrace stacktrace) {
    String errID = id.uuid();
    String msg = e.toString().replaceAll('Exception: ', '');
    String stack = beautyStack(stacktrace);
    printToConsole('$HEAD${head(this)}$END/$msg $NOUN($errID)\n$NOUN2$stack');

    analytic.error(this, msg, stack, errID);
    return errID;
  }
}

/// create log head, like application.identity.where:
///
///     String head = head();
String head(String where) {
  String text = '${envAppID}/$where';
  if (envUserID != '') {
    text = envUserID + "@" + text;
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
