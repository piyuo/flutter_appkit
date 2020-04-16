import 'dart:core';
import 'package:flutter/material.dart';
import 'package:libcli/i18n.dart';

/// requiredValidator validate input string, return error message when input is empty, other return null
///
///  use title to set error message title
///
///     String error = requiredValidator(context, nameField.value,''title);
///
String requiredValidator(BuildContext context, String input, String title) {
  return input.length > 0
      ? null
      : '@required'.i18n(context).replaceAll('%1', title);
}

/// regexpValidator validate input string using regex, return error message when input not valid, other return null
///
///  use  title and example to set proper error message
///
///     RegExp regexp = RegExp(r"^[A-Za-z]");
///     String error = regexpValidator(context, nameField.value, regexp, 'title', 'A-z')
///
String regexpValidator(
  BuildContext context,
  String input,
  RegExp regexp,
  String title,
  String example,
) {
  return regexp.hasMatch(input)
      ? null
      : '@validator'
          .i18n(context)
          .replaceAll('%1', title)
          .replaceAll('%2', example);
}

/// emailRegexp regexp use to validate email
///
/// Stop Validating Email Addresses With Regex
/// https://davidcel.is/posts/stop-validating-email-addresses-with-regex/
///
RegExp emailRegexp() {
  return RegExp(r".+@.+\..+");
}

/// emailValidator validate input string is email, return error message when input not valid, other return null
///
///     String error = emailValidator(context, 'johndoe@domain.com');
///
String emailValidator(BuildContext context, String input) {
  return regexpValidator(
    context,
    input,
    emailRegexp(),
    '@email'.i18n(context),
    'johndoe@domain.com',
  );
}

/// domainNameRegexp regexp use to validate domain name
///
RegExp domainNameRegexp() {
  return RegExp(
      r"(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]");
}

/// domainNameValidator validate input string is domain name, return error message when input not valid, other return null
///
///     String error = domainNameValidator(context, 'johndoe@domain.com');
///
String domainNameValidator(BuildContext context, String input) {
  return regexpValidator(
    context,
    input,
    domainNameRegexp(),
    '@domain'.i18n(context),
    'www.domain.com',
  );
}

/// urlRegexp regexp use to validate url
///
RegExp urlRegexp() {
  return RegExp(r"^(https?)://[^\s/$.?#].[^\s]*$");
}

/// urlValidator validate input string is url, return error message when input not valid, other return null
///
///     String error = urlValidator(context, 'http://www.g.com');
///
String urlValidator(BuildContext context, String input) {
  return regexpValidator(
    context,
    input,
    urlRegexp(),
    '@url'.i18n(context),
    'http://www.domain.com',
  );
}
