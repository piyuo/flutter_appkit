import 'dart:convert';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:libcli/google/google.dart' as google;
import 'timestamp.dart';

/// Builder function will create empty object instance
typedef Builder<T> = T Function();

/// ObjectBuilder build object from id and binary data
typedef ObjectBuilder<Object> = Object Function(int id, List<int> bytes);

/// Object is data transfer object that use protobuf format
///
abstract class Object extends $pb.GeneratedMessage implements Comparable<Object> {
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

  /// model is defined model
  common.Model? get model => null;

  /// id is model id, it is a read only field, if you want to change it use backend service to modify database
  String get id => model != null ? model!.i : '';

  /// timestamp contain last update time, it is a read only field, if you want to change it use backend service to modify database
  google.Timestamp get timestamp => model != null ? model!.t : google.Timestamp();

  /// timestamp contain last update time in utc, it is a read only field, if you want to change it use backend service to modify database
  DateTime get utcTime => timestamp.toDateTime();

  /// deleted return true if model mark as deleted, it is a read only field, if you want to change it use backend service to modify database
  bool get deleted => model != null && model!.d;

  /// deleted set deleted flag
  set deleted(bool value) {
    if (model != null) {
      model!.d = value;
    }
    updateTime();
  }

  /// updateTime update object's timestamp to current utc time
  void updateTime() {
    if (model != null) {
      model!.t = DateTime.now().timestamp;
    }
  }

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

  /// sort list of DataIndex by time, from new to old
  static void sort(List<Object> list) => list.sort((Object a, Object b) {
        return b.timestamp.toDateTime().compareTo(a.timestamp.toDateTime());
      });
}
