import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';

extension Utils on XFile {
  /// toBytes return bytes from file that can use in protobuf
  /// ```dart
  /// final  protoBuf.bytes = await file.toBytes();
  /// ```
  Future<List<int>> toBytes() async {
    final bytes = await readAsBytes();
    return Uint8List.view(bytes.buffer);
  }
}
