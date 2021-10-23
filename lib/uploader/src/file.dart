import 'package:mime/mime.dart';
import 'dart:typed_data';

abstract class File {
  File({this.mimeType = ''});

  /// mime type of file
  String mimeType;

  /// getFileSize get the size of the file
  Future<int> getFileSize();

  /// readAsBytes synchronously read the entire file contents as a list of bytes.
  Future<Uint8List> readAsBytes();

  /// setMimeType set determined mime type, leave mimeType empty if can not determine
  Future<void> setMimeType(String? fileMime, String filename) async {
    if (fileMime != null) {
      mimeType = fileMime;
      return;
    }
    String? mime = lookupMimeType(filename);
    if (mime != null) {
      mimeType = mime;
      return;
    }

    // no luck on name, try header bytes
    final bytes = await readAsBytes();
    mime = lookupMimeType(filename, headerBytes: bytes);
    if (mime != null) {
      mimeType = mime;
      return;
    }
  }
}

class MemoryFile extends File {
  MemoryFile({
    required String mimeType,
    required this.bytes,
  }) : super(mimeType: mimeType);

  /// bytes is image raw data
  Uint8List bytes;

  /// getFileSize get the size of the file
  @override
  Future<int> getFileSize() async => bytes.length;

  /// readAsBytes synchronously read the entire file contents as a list of bytes.
  @override
  Future<Uint8List> readAsBytes() async => bytes;
}
