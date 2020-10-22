import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/preference.dart' as preference;
import 'package:libcli/command.dart';
import 'package:libcli/commands/shared/err.pb.dart';
import 'package:libcli/commands/shared/text.pb.dart' as sharedText;
import 'package:libcli/commands/shared/num.pb.dart';
import 'package:libcli/commands/shared/bool.pb.dart';


/// OK is empty string which is mean empty error is OK
///
const OK = '';

/// isOK check if response is Err object and error code is empty
///
bool isOK(dynamic response) {
  return response is Err && response.code.isEmpty;
}

/// ok return Err with OK
///
Err ok() {
  return Err()..code = OK;
}

/// error return Err with error code
///
Err error(String errorCode) {
  return Err()..code = errorCode;
}

/// setErrState set state['err'], null if response is null, '' if response is not null,'error code' if response is err code
///
void setErrState(Map state, ProtoObject response) {
  if (response == null) {
    state['err'] = null;
    return;
  }
  state['err'] = '';
  if (response is Err) {
    state['err'] = response.code;
  }
}

/// text return shared text object
///
sharedText.Text text(String value) {
  return sharedText.Text()..value = value;
}

/// number return shared number object
///
Num number(int value) {
  return Num()..value = value;
}

/// number return shared number object
///
Bool boolean(bool value) {
  return Bool()..value = value;
}

/// mockCommand Initializes the value for testing
///
///     command.mockCommand({});
///
@visibleForTesting
void mockCommand() {
  // ignore:invalid_use_of_visible_for_testing_member
  preference.mockPrefs({});
}
