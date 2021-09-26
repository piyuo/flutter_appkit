import 'package:protobuf/protobuf.dart' as $pb;

/// PbObject is data transfer object that use protobuf format
///
abstract class Object extends $pb.GeneratedMessage {
  int mapIdXXX();

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
}
