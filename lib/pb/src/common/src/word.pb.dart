//
//  Generated code. Do not modify.
//  source: word.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

import 'word.pbenum.dart';

export 'word.pbenum.dart';

/// Word used in chat message, it represents a word (like text, image, etc.)
class Word extends pb.Object {
  $core.int mapIdXXX() => 9;
  get namespace => 'common';

  factory Word({
    Word_WordType? type,
    $core.String? value,
    $core.double? ratio,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (value != null) {
      $result.value = value;
    }
    if (ratio != null) {
      $result.ratio = ratio;
    }
    return $result;
  }
  Word._() : super();
  factory Word.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Word.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Word', createEmptyInstance: create)
    ..e<Word_WordType>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: Word_WordType.WORD_TYPE_UNSPECIFIED, valueOf: Word_WordType.valueOf, enumValues: Word_WordType.values)
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'ratio', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Word clone() => Word()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Word copyWith(void Function(Word) updates) => super.copyWith((message) => updates(message as Word)) as Word;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Word create() => Word._();
  Word createEmptyInstance() => create();
  static $pb.PbList<Word> createRepeated() => $pb.PbList<Word>();
  @$core.pragma('dart2js:noInline')
  static Word getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Word>(create);
  static Word? _defaultInstance;

  @$pb.TagNumber(1)
  Word_WordType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Word_WordType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  /// / value for then type
  /// / if type is text, then value is the input text
  /// / if type is image, then value is the image url
  /// / if type is video, then value is the video url
  /// / if type is audio, then value is the audio url
  /// / if type is file, then value is the file url
  /// / if type is emoji, then value is the emoji value
  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  /// / ratio is the display ratio of the word, it is used for image, video
  @$pb.TagNumber(3)
  $core.double get ratio => $_getN(2);
  @$pb.TagNumber(3)
  set ratio($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearRatio() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
