import 'dart:core';
import 'dart:convert';
import 'package:libcli/log/log.dart' as log;
import 'package:libcli/util/util.dart' as util;
import 'app.dart';

class ErrorEmail {
  final String _subject = 'Report an error';

  final String _body = '''

Application:\n    $appName

Debug Information
------------------------------------------------
''';

  String get encodedLogs {
    String logs = log.printLogs();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(logs);
  }

  void launchMailTo() async {
    util.openMailTo(
      serviceEmail,
      _subject,
      _body.replaceAll('\n', '%0D%0A') + encodedLogs,
    );
  }
}
