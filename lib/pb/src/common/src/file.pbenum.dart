///
//  Generated code. Do not modify.
//  source: file.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class File_FileType extends $pb.ProtobufEnum {
  static const File_FileType FILE_TYPE_UNSPECIFIED = File_FileType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_UNSPECIFIED');
  static const File_FileType FILE_TYPE_JPG = File_FileType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_JPG');
  static const File_FileType FILE_TYPE_PNG = File_FileType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_PNG');
  static const File_FileType FILE_TYPE_GIF = File_FileType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_GIF');
  static const File_FileType FILE_TYPE_BMP = File_FileType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_BMP');
  static const File_FileType FILE_TYPE_TIFF = File_FileType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_TIFF');
  static const File_FileType FILE_TYPE_TGA = File_FileType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_TGA');
  static const File_FileType FILE_TYPE_PVR = File_FileType._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_PVR');
  static const File_FileType FILE_TYPE_ICO = File_FileType._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_ICO');
  static const File_FileType FILE_TYPE_WEBP = File_FileType._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_WEBP');
  static const File_FileType FILE_TYPE_PSD = File_FileType._(10, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_PSD');
  static const File_FileType FILE_TYPE_EXR = File_FileType._(11, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'FILE_TYPE_EXR');

  static const $core.List<File_FileType> values = <File_FileType> [
    FILE_TYPE_UNSPECIFIED,
    FILE_TYPE_JPG,
    FILE_TYPE_PNG,
    FILE_TYPE_GIF,
    FILE_TYPE_BMP,
    FILE_TYPE_TIFF,
    FILE_TYPE_TGA,
    FILE_TYPE_PVR,
    FILE_TYPE_ICO,
    FILE_TYPE_WEBP,
    FILE_TYPE_PSD,
    FILE_TYPE_EXR,
  ];

  static final $core.Map<$core.int, File_FileType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static File_FileType? valueOf($core.int value) => _byValue[value];

  const File_FileType._($core.int v, $core.String n) : super(v, n);
}

