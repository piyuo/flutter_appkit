import 'package:libcli/pb/src/common/common.dart' as common;
import 'package:cross_file/cross_file.dart';

/// isOK return true if obj is OK
/// ```dart
/// isOK(response);
/// ```
bool isOK(dynamic obj) => obj is common.OK;

/// isError return true if obj is Error and code==code
/// ```dart
/// isError(response,'code-1');
/// ```
bool isError(dynamic obj, String code) {
  if (obj is common.Error) {
    return obj.code == code;
  }
  return false;
}

/// getFileTypeFromMime return FileType from mimeType
common.File_FileType getFileTypeFromMime(String? mimeType) {
  switch (mimeType) {
    case 'image/jpeg':
      return common.File_FileType.FILE_TYPE_JPG;
    case 'image/png':
      return common.File_FileType.FILE_TYPE_PNG;
    case 'image/gif':
      return common.File_FileType.FILE_TYPE_GIF;
    case 'image/bmp':
      return common.File_FileType.FILE_TYPE_BMP;
    case 'image/tiff':
      return common.File_FileType.FILE_TYPE_TIFF;
    case 'image/tga':
      return common.File_FileType.FILE_TYPE_TGA;
    case 'image/pvr':
      return common.File_FileType.FILE_TYPE_PVR;
    case 'image/ico':
      return common.File_FileType.FILE_TYPE_ICO;
    case 'image/webp':
      return common.File_FileType.FILE_TYPE_WEBP;
    case 'image/psd':
      return common.File_FileType.FILE_TYPE_PSD;
    case 'image/exr':
      return common.File_FileType.FILE_TYPE_EXR;
    default:
      return common.File_FileType.FILE_TYPE_UNSPECIFIED;
  }
}

/// FileUtil provide toFile method for XFile
extension FileUtil on XFile {
  /// toFile convert XFile to File
  Future<common.File> toFile() async {
    return common.File(
      name: name,
      type: getFileTypeFromMime(mimeType),
      data: await readAsBytes(),
    );
  }
}
