import 'dart:core';
import 'package:libcli/i18n.dart';

/// requiredValidator validate input string, return error message when input is empty, return empty is no error
///
///  use title to set error message title
///
///     String error = requiredValidator(nameField.value,title);
///
String? requiredValidator(String? input, String title) {
  if (input == null) {
    return null;
  }
  return input.length > 0 ? '' : 'required'.i18n_.replaceAll('%1', title);
}

/// regexpValidator validate input string using regex, return error message when input not valid, other return null
///
///  use  title and example to set proper error message
///
///     RegExp regexp = RegExp(r"^[A-Za-z]");
///     String error = regexpValidator(nameField.value, regexp, 'title', 'A-z')
///
String? regexpValidator(
  String? input,
  RegExp regexp,
  String title,
  String example,
) {
  if (input == null) {
    return null;
  }
  return regexp.hasMatch(input) ? '' : 'valid'.i18n_.replaceAll('%1', title).replaceAll('%2', example);
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
    input,
    emailRegexp(),
    'emailAdr'.i18n_,
    'johndoe@domain.com',
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
    input,
    domainNameRegexp(),
    'domain'.i18n_,
    'www.domain.com',
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
    input,
    subDomainNameRegexp(),
    'domain'.i18n_,
    'your-name',
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
    input,
    noSymbolRegexp(),
    'domain'.i18n_,
    'your-name',
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
    input,
    urlRegexp(),
    'url'.i18n_,
    'http://www.domain.com',
  );
}
