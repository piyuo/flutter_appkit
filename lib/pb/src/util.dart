import 'package:libcli/pb/src/common/common.dart' as common;

/// isOK return true if obj is OK
///
///     isOK(response);
///
bool isOK(dynamic obj) {
  return obj is common.OK;
}

/// isError return true if obj is Error and code==code
///
///     isError(response,'code-1');
///
bool isError(dynamic obj, String code) {
  if (obj is common.Error) {
    return obj.code == code;
  }
  return false;
}
