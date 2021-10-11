import 'package:mime/mime.dart';
import 'dart:typed_data';

abstract class File {
  /// mime type of file
  String mimeType = '';

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
