import 'dart:core';
import 'package:libcli/src/support/error_record.dart';
import 'package:libcli/configuration.dart' as configuration;

class ErrorEmailBuilder {
  String _subject = 'report error ';

  String _body = ''''
  Application:\n${configuration.appID}\n\n
  Account:\n${configuration.userID}
  ''';

  String get to => Uri.encodeComponent(configuration.supportEmail);

  String get subject => Uri.encodeComponent(_subject);

  String get body => Uri.encodeComponent(_body);

  add(ErrorRecord record) {
    _subject += record.id + ',';
    _body += 'error: ${record.id}\n${record.e}\n${record.stacktrace}';
  }
}
