import 'dart:core';
import 'package:libcli/i18n/i18n.dart' as i18n;
import 'package:flutter/material.dart';

/*
/// requiredValidator validate input string, return error message when input is empty, return null if no error
///
///  use title to set error message title
///
///     String error = requiredValidator(nameField.value,title);
///
String? requiredValidator({
  String? input,
  required String label,
  bool enterYour: false,
  int minLength = 0,
  int maxLength = 65535,
}) {
  assert(minLength < maxLength, 'minLength($minLength) must small than maxLength($maxLength)');
  String? result = null;
  if (input == null || input.isEmpty) {
    if (enterYour) {
      result = 'enterYour'.i18n_.replaceAll('%1', label);
    } else {
      result = 'required'.i18n_.replaceAll('%1', label);
    }
  } else {
    if (input.length < minLength) {
      result =
          'minLength'.i18n_.replaceAll('%1', label).replaceAll('%2', '$minLength').replaceAll('%3', '${input.length}');
    }
    if (input.length > maxLength) {
      result =
          'maxLength'.i18n_.replaceAll('%1', label).replaceAll('%2', '$maxLength').replaceAll('%3', '${input.length}');
    }
  }
  if (result != null) {
    log.debug('validation failed: $result');
  }
  return result;
}
*/
/// regexpValidator validate input string using regex, return error message when input not valid, otherwise return null
///
///  use  title and example to set proper error message
///
///     RegExp regexp = RegExp(r"^[A-Za-z]");
///     String error = regexpValidator(nameField.value, regexp, 'title', 'A-z')
///
String? regexpValidator(
  BuildContext context, {
  String? input,
  required RegExp regexp,
  required String label,
  required String example,
}) {
  if (input == null) {
    return null;
  }
  var result =
      regexp.hasMatch(input) ? null : context.i18n.fieldValueInvalid.replaceAll('%1', label).replaceAll('%2', example);
  if (result != null) {
    debugPrint('[validator] failed $result');
  }
  return result;
}

/// emailRegexp regexp use to validate email
///
/// Stop Validating Email Addresses With Regex
/// https://davidcel.is/posts/stop-validating-email-addresses-with-regex/
///
RegExp get emailRegexp => RegExp(r".+@.+\..+");

/// emailValidator validate input string is email, return error message when input not valid, other return null
///
///     String error = emailValidator(context,'johndoe@domain.com');
///
String? emailValidator(BuildContext context, String? input) {
  return regexpValidator(
    context,
    input: input,
    regexp: emailRegexp,
    label: context.i18n.emailField,
    example: 'johndoe@domain.com',
  );
}

/// domainNameRegexp regexp use to validate domain name
///
RegExp get domainNameRegexp => RegExp(r"(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]");

/// domainNameValidator validate input string is domain name, return error message when input not valid, other return null
///
///     String error = domainNameValidator(context,'johndoe@domain.com');
///
String? domainNameValidator(BuildContext context, String? input) {
  return regexpValidator(
    context,
    input: input,
    regexp: domainNameRegexp,
    label: context.i18n.domainField,
    example: 'domain.com',
  );
}

/// subDomainNameRegexp regexp use to validate domain name
///
RegExp get subDomainNameRegexp => RegExp(r"^[a-zA-Z0-9-]*[a-zA-Z0-9]$");

/// domainNameValidator validate input string is domain name, return error message when input not valid, other return null
///
///     String error = domainNameValidator(context,'johndoe@domain.com');
///
String? subDomainNameValidator(BuildContext context, String? input) {
  return regexpValidator(
    context,
    input: input,
    regexp: subDomainNameRegexp,
    label: context.i18n.domainField,
    example: 'domain.com',
  );
}

/// nameRegexp regexp use to validate name, character and space only
///
RegExp get noSymbolRegexp => RegExp(r"""^[^*|\":<>[\]{}`\\()';!@#%^*?&$.~,\-_=+\/]+$""");

/*
/// nameValidator validate input string is character and space only, return error message when input not valid, other return null
///
///     String error = domainNameValidator('johndoe@domain.com');
///
String? noSymbolValidator(String? input) {
  return regexpValidator(
    input: input,
    regexp: noSymbolRegexp,
    label: 'domain'.i18n_,
    example: 'your-name',
  );
}
*/
/// urlRegexp regexp use to validate url
///
RegExp get urlRegexp => RegExp(r"^(https?)://[^\s/$.?#].[^\s]*$");

/// urlValidator validate input string is url, return error message when input not valid, other return null
///
///     String error = urlValidator('http://www.g.com');
///
String? urlValidator(BuildContext context, String? input) {
  return regexpValidator(
    context,
    input: input,
    regexp: urlRegexp,
    label: context.i18n.urlField,
    example: 'http://www.domain.com',
  );
}

/// chineseOrJapaneseRegexp regexp use to check chinese or japanese character exists
///
RegExp get chineseOrJapaneseRegexp =>
    RegExp(r"(?:[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff66-\uff9f])");

/// ipAddressRegexp regexp use to check ip address
///
RegExp get ipAddressRegexp => RegExp(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$");
