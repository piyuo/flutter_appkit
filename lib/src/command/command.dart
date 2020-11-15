import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libcli/preference.dart' as preference;
import 'package:libpb/pb.dart';

/// OK is empty string which is mean empty error is OK
///
const OK = '';

/// isOK check if response is Err object and error code is empty
///
bool isOK(dynamic response) {
  return response is PbError && response.code.isEmpty;
}

/// ok return Err with OK
///
PbError ok() {
  return PbError()..code = OK;
}

/// error return Err with error code
///
PbError error(String errorCode) {
  return PbError()..code = errorCode;
}

/// setErrState set state['err'], null if response is null, '' if response is not null,'error code' if response is err code
///
void setErrState(Map state, ProtoObject? response) {
  if (response == null) {
    state['err'] = null;
    return;
  }
  state['err'] = '';
  if (response is PbError) {
    state['err'] = response.code;
  }
}

/// newPbString return shared text object
///
PbString newPbString(String value) {
  return PbString()..value = value;
}

/// newPbInt return shared number object
///
PbInt newPbInt(int value) {
  return PbInt()..value = value;
}

/// number return shared number object
///
PbBool newPbBool(bool value) {
  return PbBool()..value = value;
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
