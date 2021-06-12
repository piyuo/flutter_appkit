import 'package:protobuf/protobuf.dart' as $pb;

/// PbObject is data transfer object that use ptotobuf format
///
abstract class Object extends $pb.GeneratedMessage {
  int mapIdXXX();

  /// jsonString return object in json format string
  ///
  ///     final text = jsonString;
  ///
  String get jsonString {
    var text = toString().replaceAll('\n', '');
    return '$runtimeType{$text}';
  }
}
