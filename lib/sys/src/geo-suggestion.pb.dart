//
//  Generated code. Do not modify.
//  source: geo-suggestion.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  GeoSuggestion keep geo suggestion information
///
/// 	key {string} the key of suggestion, can use key to get location detail, like '1'
/// 	text {string} is geo suggestion text, like '1 apple park, irvine, ca 92618'
class GeoSuggestion extends net.Object {
  $core.int mapIdXXX() => 1005;
  get namespace => 'sys';

  factory GeoSuggestion({
    $core.String? key,
    $core.String? text,
  }) {
    final $result = create();
    if (key != null) {
      $result.key = key;
    }
    if (text != null) {
      $result.text = text;
    }
    return $result;
  }
  GeoSuggestion._() : super();
  factory GeoSuggestion.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeoSuggestion.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GeoSuggestion', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeoSuggestion clone() => GeoSuggestion()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeoSuggestion copyWith(void Function(GeoSuggestion) updates) => super.copyWith((message) => updates(message as GeoSuggestion)) as GeoSuggestion;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeoSuggestion create() => GeoSuggestion._();
  GeoSuggestion createEmptyInstance() => create();
  static $pb.PbList<GeoSuggestion> createRepeated() => $pb.PbList<GeoSuggestion>();
  @$core.pragma('dart2js:noInline')
  static GeoSuggestion getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoSuggestion>(create);
  static GeoSuggestion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
