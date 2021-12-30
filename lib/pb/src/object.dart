import 'dart:convert';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:libcli/pb/src/google/google.dart' as google;

/// Factory function will create empty instance
typedef Factory<T> = T Function();

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

  /// toJson return object in json format string
  ///
  ///     final text = toJson();
  ///
  String toJson() => writeToJson();

  /// fromJsonMap set object from json format map
  ///
  ///     final jsonMap = json.decode(jText) as Map<String, dynamic>;
  ///     final obj2 = Error()..fromJsonMap(jsonMap);
  ///
  void fromJsonMap(Map<String, dynamic> json) => mergeFromJsonMap(json);

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

  /// getEntity return object defined entity
  common.Entity? getEntity() => null;

  /// entityId return entity id
  String get entityId {
    assert(getEntity() != null, '$runtimeType not define entity');
    return getEntity()!.id;
  }

  /// entityUpdateTime return entity update time stamp
  google.Timestamp get entityUpdateTime {
    assert(getEntity() != null, '$runtimeType not define entity');
    return getEntity()!.updateTime;
  }

  /// entityNotGoingToChange return true if entity not going to change
  bool get entityNotGoingToChange {
    assert(getEntity() != null, '$runtimeType not define entity');
    return getEntity()!.notGoingToChange;
  }

  /// entityDeleted return true if entity mask as deleted
  bool get entityDeleted {
    assert(getEntity() != null, '$runtimeType not define entity');
    return getEntity()!.deleted;
  }
}
