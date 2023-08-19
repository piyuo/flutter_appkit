//
//  Generated code. Do not modify.
//  source: word.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Word_WordType extends $pb.ProtobufEnum {
  static const Word_WordType WORD_TYPE_UNSPECIFIED = Word_WordType._(0, _omitEnumNames ? '' : 'WORD_TYPE_UNSPECIFIED');
  static const Word_WordType WORD_TYPE_TEXT = Word_WordType._(1, _omitEnumNames ? '' : 'WORD_TYPE_TEXT');
  static const Word_WordType WORD_TYPE_IMAGE = Word_WordType._(2, _omitEnumNames ? '' : 'WORD_TYPE_IMAGE');
  static const Word_WordType WORD_TYPE_VIDEO = Word_WordType._(3, _omitEnumNames ? '' : 'WORD_TYPE_VIDEO');
  static const Word_WordType WORD_TYPE_AUDIO = Word_WordType._(4, _omitEnumNames ? '' : 'WORD_TYPE_AUDIO');
  static const Word_WordType WORD_TYPE_FILE = Word_WordType._(5, _omitEnumNames ? '' : 'WORD_TYPE_FILE');
  static const Word_WordType WORD_TYPE_EMOJI = Word_WordType._(6, _omitEnumNames ? '' : 'WORD_TYPE_EMOJI');

  static const $core.List<Word_WordType> values = <Word_WordType> [
    WORD_TYPE_UNSPECIFIED,
    WORD_TYPE_TEXT,
    WORD_TYPE_IMAGE,
    WORD_TYPE_VIDEO,
    WORD_TYPE_AUDIO,
    WORD_TYPE_FILE,
    WORD_TYPE_EMOJI,
  ];

  static final $core.Map<$core.int, Word_WordType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Word_WordType? valueOf($core.int value) => _byValue[value];

  const Word_WordType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
