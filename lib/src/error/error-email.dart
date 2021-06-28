import 'dart:core';
import 'dart:convert';
import 'package:libcli/env.dart' as env;
import 'package:libcli/log.dart' as log;
import 'package:url_launcher/url_launcher.dart';

class ErrorEmail {
  String _subject = 'Report an error';

  String _body = '''

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

  String get to => env.serviceEmail;

  String get subjectUrlSafe => Uri.encodeComponent(_subject);

  String get bodyUrlSafe => Uri.encodeComponent(_body.trim()).replaceAll('\n', '%0D%0A') + encodedLogs;

  String get linkMailTo {
    return 'mailto:${to}?Subject=${subjectUrlSafe}&body=${bodyUrlSafe}';
  }

  void launchMailTo() async {
    var url = linkMailTo;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
      );
    }
  }
}
