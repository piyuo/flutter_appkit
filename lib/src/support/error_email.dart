import 'dart:core';
import 'package:libcli/src/support/error_record.dart';
import 'package:libcli/configuration.dart' as configuration;

class ErrorEmailBuilder {
  String _subject = 'report error ';

  String _body = ''''
  Application:\n${configuration.appID}\n\n
  Account:\n${configuration.userID}
  ''';

  String get to => configuration.supportEmail;

  String get subject => _subject.trim();

  String get body => _body.trim();

  String get toUrlSafe => Uri.encodeComponent(to);

  String get subjectUrlSafe => Uri.encodeComponent(subject);

  String get bodyUrlSafe => Uri.encodeComponent(body);

  add(ErrorRecord record) {
    _subject += record.id + ' ';
    _body +=
        'error: ${record.id}\n${record.exception}\n${record.stackTrace}\n\n';
  }
}
