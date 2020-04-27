import 'dart:core';
import 'package:libcli/log.dart' as log;
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

  addReports(List<log.ErrorReport> reports) {
    for (var report in reports) {
      addException(report.analyticID, report.exception, report.stackTrace);
    }
  }

  addException(String analyticID, dynamic exception, String stackTrace) {
    if (analyticID != null) {
      _subject += analyticID + ' ';
    }
    _body += 'error: ${analyticID ?? ''}\n${exception}\n${stackTrace}\n\n';
  }
}
