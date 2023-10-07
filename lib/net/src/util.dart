import 'package:mime/mime.dart';
import 'package:libcli/common/common.dart' as common;
import 'package:cross_file/cross_file.dart';

/// isMimeImage return true if mime is image
bool isMimeImage(String mime) => mime.startsWith('image/');

/// isMimeVideo return true if mime is video
bool isMimeVideo(String mime) => mime.startsWith('video/');

/// isMimeAudio return true if mime is audio
bool isMimeAudio(String mime) => mime.startsWith('audio/');

/// FileUtil provide toFile method for XFile
extension FileUtil on XFile {
  /// isImage return true if mime is image
  bool get isImage => isMimeImage(mimeTypeByLookup);

  /// isVideo return true if mime is video
  bool get isVideo => isMimeVideo(mimeTypeByLookup);

  /// isAudio return true if mime is audio
  bool get isAudio => isMimeAudio(mimeTypeByLookup);

  /// mimeTypeByLookup try to get mime type by lookupMimeType
  String get mimeTypeByLookup => mimeType ?? lookupMimeType(path) ?? 'application/octet-stream';

  /// toFile convert XFile to File
  Future<common.File> toFile() async {
    return common.File(
      name: name,
      mime: mimeTypeByLookup,
      data: await readAsBytes(),
    );
  }
}
