import 'dart:core';
import 'dart:convert';
import 'package:libcli/app.dart';
import 'package:libcli/log.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorEmail {
  String _subject = 'Report an error';

  String _body = '''

Application:\n    ${appID}

Account:\n    ${userID}

Debug Information
------------------------------------------------
''';

  String get encodedLogs {
    String logs = printLogs();
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(logs);
  }

  String get to => supportEmail;

  String get subjectUrlSafe => Uri.encodeComponent(_subject);

  String get bodyUrlSafe => Uri.encodeComponent(_body.trim()).replaceAll('\n', '%0D%0A') + encodedLogs;

  String get linkMailTo {
    return 'mailto:${to}?Subject=${subjectUrlSafe}&body=${bodyUrlSafe}';
  }

  ///todo:add exception from logs
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
