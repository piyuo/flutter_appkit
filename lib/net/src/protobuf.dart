import 'dart:typed_data';
import 'object.dart';
import 'empty.dart';
import '../common/common.dart' as common;

/// encode protobuf object into bytes
/// ```dart
/// EchoAction echoAction = EchoAction();
/// echoAction.text = 'hi';
/// List<int> bytes = commandProtobuf.encode(echoAction);
/// ```
Uint8List encode(Object obj) {
  Uint8List bytes = obj.writeToBuffer();
  Uint8List list = Uint8List(bytes.length + 2);
  list.setRange(0, bytes.length, bytes);
  int id = obj.mapIdXXX();
  list[list.length - 2] = id & 0xff;
  list[list.length - 1] = (id >> 8) & 0xff;
  return list;
}

/// decode bytes array to protobuf object, set builder if result is anything other than common objects
/// ```dart
/// EchoAction decodeAction = commandProtobuf.decode(bytes, builder);
/// expect(decodeAction.text, 'hi');
/// ```
Object decode(List<int> bytes, Builder? builder) {
  List<int> protoBytes = bytes.sublist(0, bytes.length - 2);
  Uint8List idBytes = Uint8List.fromList(bytes.sublist(bytes.length - 2, bytes.length));
  final id = idBytes.buffer.asByteData().getInt16(0, Endian.little);

  // common objects like error, ok
  if (id <= 1000) {
    return common.objectBuilder(id, protoBytes);
  }
  if (builder != null) {
    final obj = builder();
    assert(obj.mapIdXXX() == id, 'expect object with id ${obj.mapIdXXX()} but got $id');
    obj.mergeFromBuffer(protoBytes);
    return obj;
  }
  assert(false, 'unexpected id $id, please set builder to decode it');
  return empty;
}
