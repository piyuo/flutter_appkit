import 'dart:core';
import 'dart:convert';
import 'package:libcli/env.dart' as env;
import 'package:libcli/log.dart' as log;
import 'package:libcli/util.dart' as util;

class ErrorEmail {
  final String _subject = 'Report an error';

  final String _body = '''

Application:\n    ${env.appName}

Account:\n    ${env.userID}

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
      env.serviceEmail,
      _subject,
      _body.replaceAll('\n', '%0D%0A') + encodedLogs,
    );
  }
}
