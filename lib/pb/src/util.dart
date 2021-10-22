import 'simple/types.dart' as types;

/// isOK return true if obj is OK
///
///     isOK(response);
///
bool isOK(dynamic obj) {
  return obj is types.OK;
}

/// isError return true if obj is Error and code==code
///
///     isError(response,'code-1');
///
bool isError(dynamic obj, String code) {
  if (obj is types.Error) {
    return obj.code == code;
  }
  return false;
}

/// isString return true if obj is String and value is the same
///
///     isString(response,'hi');
///
bool isString(dynamic obj, String value) {
  if (obj is types.String) {
    return obj.value == value;
  }
  return false;
}

/// isBool return true if obj is Bool and value is the same
///
///     isBool(response,true);
///
bool isBool(dynamic obj, bool value) {
  if (obj is types.Bool) {
    return obj.value == value;
  }
  return false;
}

/// isNumber return true if obj is number and value is the same
///
///     isNumber(response,16);
///
bool isNumber(dynamic obj, int value) {
  if (obj is types.Number) {
    return obj.value == value;
  }
  return false;
}
