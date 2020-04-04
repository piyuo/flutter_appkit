import 'dart:core';
import 'package:flutter/material.dart';
import 'package:libcli/i18n/i18n.dart';

String regexpValidator(
  BuildContext context,
  String regex,
  String input,
  String name,
  String example,
) {
  final regexp = new RegExp(
    regex,
    caseSensitive: false,
    multiLine: false,
  );

  return regexp.hasMatch(input)
      ? null
      : '@validator'
          .i18n(context)
          .replaceAll('%1', name)
          .replaceAll('%2', example);
}

String emailValidator(BuildContext context, String input) {
  return regexpValidator(
      context,
      r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)",
      input,
      '@email'.i18n(context),
      'johndoe@domain.com');
}

String domainNameValidator(BuildContext context, String input) {
  return regexpValidator(
      context,
      r"(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]",
      input,
      '@domain'.i18n(context),
      'www.domain.com');
}

String urlValidator(BuildContext context, String input) {
  return regexpValidator(context, r"^(https?)://[^\s/$.?#].[^\s]*$", input,
      '@url'.i18n(context), 'http://www.domain.com');
}
