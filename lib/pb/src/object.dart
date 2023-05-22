import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:libcli/google/google.dart' as google;
import 'package:libcli/generator/generator.dart' as generator;

/// Builder function will create empty object instance
typedef Builder<T> = T Function();

/// ObjectBuilder build object from id and binary data
typedef ObjectBuilder<Object> = Object Function(int id, List<int> bytes);

/// Object is data transfer object that use protobuf format
///
abstract class Object extends $pb.GeneratedMessage implements Comparable<Object> {
  Object() {
    if (hasModel) {
      model = common.Model(
        d: false,
        i: generator.uuid(),
        t: google.Timestamp(),
      );
    }
  }

  /// mapIdXXX return map id let service create object by id
  int mapIdXXX();

  /// compareTo other object, must implement if using data source
  @override
  int compareTo(Object other) => -1;

  /// jsonString return object in json format string
  ///
  ///     final text = jsonString;
  ///
  String get jsonString {
    var text = toString();
    return '$runtimeType{$text}';
  }

  /// toBase64 return object in base64 string
  ///
  ///     final text = Error()..toBase64();
  ///
  String toBase64() {
    var bytes = writeToBuffer();
    return base64.encode(bytes);
  }

  /// fromBase64 set object from base64 string
  ///
  ///     final obj = Error()..fromBase64(text);
  ///
  void fromBase64(String text) {
    var bytes = base64.decode(text);
    mergeFromBuffer(bytes);
  }

  /// namespace return object namespace, usually is package name
  String get namespace => '';

  /// hasModel return true if model is defined
  bool get hasModel => false;

  /// model is defined model
  common.Model? get model => null;

  /// model is defined model
  set model(common.Model? value) {}

  /// id is model id
  String get id => model != null ? model!.i : '';

  /// id is model id
  @visibleForTesting
  set id(value) => model != null ? model!.i = value : null;

  /// lastUpdateTime is model last update time
  google.Timestamp get lastUpdateTime => model != null ? model!.t : google.Timestamp();

  /// lastUpdateTime is model last update time
  @visibleForTesting
  set lastUpdateTime(value) => model != null ? model!.t = value : null;

  /// deleted return true if model mark as deleted
  bool get deleted => model != null && model!.d;

  /// markAsDeleted mark object as deleted
  set deleted(bool value) => model != null ? model!.d = value : null;

  /// setAccessToken set access token
  void setAccessToken(String token) {}

  /// accessTokenRequired return true if action object need access token
  bool get accessTokenRequired => false;

  /// isFieldExists return true if filed is exists
  bool isFieldExists(String key) {
    return getTagNumber(key) != null;
  }

  /// [] override to get field value
  operator [](String key) {
    final tagNumber = getTagNumber(key);
    if (tagNumber == null) {
      return null;
    }
    return getField(tagNumber);
  }

  /// [] override to set field value
  operator []=(String key, dynamic value) {
    final tagNumber = getTagNumber(key);
    if (tagNumber == null) {
      return;
    }
    return setField(tagNumber, value);
  }
}
