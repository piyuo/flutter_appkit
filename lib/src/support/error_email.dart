import 'dart:core';
import 'package:libcli/src/support/error_record.dart';
import 'package:libcli/configuration.dart' as configuration;
import 'package:url_launcher/url_launcher.dart';

class ErrorEmailBuilder {
  String _subject = 'report error ';

  String _body = '''

Application:\n${configuration.appID}

Account:\n${configuration.userID}

''';

  String get to => configuration.supportEmail;

  String get subject => _subject.trim();

  String get body => _body.trim();

  String get toUrlSafe => Uri.encodeComponent(to);

  String get subjectUrlSafe => Uri.encodeComponent(subject);

  String get bodyUrlSafe =>
      Uri.encodeComponent(body).replaceAll('\n', '%0D%0A');

  String get linkMailTo {
    return 'mailto:${to}?Subject=${subjectUrlSafe}&body=${bodyUrlSafe}';
  }

  void launchMailTo() async {
    var url = linkMailTo;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  add(ErrorRecord record) {
    _subject += record.id + ' ';
    _body +=
        'error: ${record.id}\n${record.exception}\n${record.stackTrace}\n\n';
  }
}
