import 'dart:typed_data';
import 'package:libcli/src/command/command.dart';
import 'package:libcli/command_type.dart';

SharedService _sharedService;

SharedService _getSharedService() {
  if (_sharedService == null) {
    _sharedService = SharedService();
  }
  return _sharedService;
}

/// encode protobuf object into bytes
///
///     EchoAction echoAction = EchoAction();
///     echoAction.text = 'hi';
///     List<int> bytes = commandProtobuf.encode(echoAction);
Uint8List encode(ProtoObject obj) {
  Uint8List bytes = obj.writeToBuffer();
  Uint8List list = Uint8List(bytes.length + 2);
  list.setRange(0, bytes.length, bytes);
  int id = obj.mapIdXXX();
  list[list.length - 2] = id & 0xff;
  list[list.length - 1] = (id >> 8) & 0xff;
  return list;
}

/// decode bytes array to protobuf object
///
///     EchoAction decodeAction = commandProtobuf.decode(bytes, service);
///     expect(decodeAction.text, 'hi');
ProtoObject decode(List<int> bytes, Service service) {
  List<int> protoBytes = bytes.sublist(0, bytes.length - 2);
  Uint8List idBytes =
      Uint8List.fromList(bytes.sublist(bytes.length - 2, bytes.length));
  final id = idBytes.buffer.asByteData().getInt16(0, Endian.little);

  ProtoObject obj;
  if (id <= 1000) {
    obj = _getSharedService().newObjectByID(id, protoBytes);
  } else {
    obj = service.newObjectByID(id, protoBytes);
  }
  if (obj == null) {
    throw new Exception('response id $id out of range');
  }
  return obj;
}
