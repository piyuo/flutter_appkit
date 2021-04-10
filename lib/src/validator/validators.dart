import 'dart:core';
import 'package:libcli/src/i18n/i18n.dart';
import 'package:libcli/src/log/log.dart';

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
          'minLenth'.i18n_.replaceAll('%1', label).replaceAll('%2', '$minLength').replaceAll('%3', '${input.length}');
    }
    if (input.length > maxLength) {
      result =
          'maxLenth'.i18n_.replaceAll('%1', label).replaceAll('%2', '$maxLength').replaceAll('%3', '${input.length}');
    }
  }
  if (result != null) {
    debug('validation failed: $result');
  }
  return result;
}

/// regexpValidator validate input string using regex, return error message when input not valid, otherwise return null
///
///  use  title and example to set proper error message
///
///     RegExp regexp = RegExp(r"^[A-Za-z]");
///     String error = regexpValidator(nameField.value, regexp, 'title', 'A-z')
///
String? regexpValidator({
  String? input,
  required RegExp regexp,
  required String label,
  required String example,
}) {
  if (input == null) {
    return null;
  }
  var result = regexp.hasMatch(input) ? null : 'valid'.i18n_.replaceAll('%1', label).replaceAll('%2', example);
  if (result != null) {
    debug('validation failed: $result');
  }
  return result;
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
///     String error = emailValidator('johndoe@domain.com');
///
String? emailValidator(String? input) {
  return regexpValidator(
    input: input,
    regexp: emailRegexp(),
    label: 'emailAdr'.i18n_,
    example: 'johndoe@domain.com',
  );
}

/// domainNameRegexp regexp use to validate domain name
///
RegExp domainNameRegexp() {
  return RegExp(r"(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]");
}

/// domainNameValidator validate input string is domain name, return error message when input not valid, other return null
///
///     String error = domainNameValidator('johndoe@domain.com');
///
String? domainNameValidator(String? input) {
  return regexpValidator(
    input: input,
    regexp: domainNameRegexp(),
    label: 'domain'.i18n_,
    example: 'www.domain.com',
  );
}

/// subDomainNameRegexp regexp use to validate domain name
///
RegExp subDomainNameRegexp() {
  return RegExp(r"^[a-zA-Z0-9-]*[a-zA-Z0-9]$");
}

/// domainNameValidator validate input string is domain name, return error message when input not valid, other return null
///
///     String error = domainNameValidator('johndoe@domain.com');
///
String? subDomainNameValidator(String? input) {
  return regexpValidator(
    input: input,
    regexp: subDomainNameRegexp(),
    label: 'domain'.i18n_,
    example: 'your-name',
  );
}

/// nameRegexp regexp use to validate name, charchter and space only
///
RegExp noSymbolRegexp() {
  return RegExp(r"""^[^*|\":<>[\]{}`\\()';!@#%^*?&$.~,\-_=+\/]+$""");
}

/// nameValidator validate input string is character and space only, return error message when input not valid, other return null
///
///     String error = domainNameValidator('johndoe@domain.com');
///
String? noSymbolValidator(String? input) {
  return regexpValidator(
    input: input,
    regexp: noSymbolRegexp(),
    label: 'domain'.i18n_,
    example: 'your-name',
  );
}

/// urlRegexp regexp use to validate url
///
RegExp urlRegexp() {
  return RegExp(r"^(https?)://[^\s/$.?#].[^\s]*$");
}

/// urlValidator validate input string is url, return error message when input not valid, other return null
///
///     String error = urlValidator('http://www.g.com');
///
String? urlValidator(String? input) {
  return regexpValidator(
    input: input,
    regexp: urlRegexp(),
    label: 'url'.i18n_,
    example: 'http://www.domain.com',
  );
}
