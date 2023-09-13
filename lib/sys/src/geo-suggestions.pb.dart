//
//  Generated code. Do not modify.
//  source: geo-suggestions.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

import 'geo-suggestion.pb.dart' as $0;

///  GeoSuggestions keep list of geo suggestion result
///
///   sessionToken {string} session token
///   result {List<GeoSuggestion>} list of suggestion
class GeoSuggestions extends net.Object {
  $core.int mapIdXXX() => 1006;
  get namespace => 'sys';

  factory GeoSuggestions({
    $core.String? sessionToken,
    $core.Iterable<$0.GeoSuggestion>? result,
  }) {
    final $result = create();
    if (sessionToken != null) {
      $result.sessionToken = sessionToken;
    }
    if (result != null) {
      $result.result.addAll(result);
    }
    return $result;
  }
  GeoSuggestions._() : super();
  factory GeoSuggestions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeoSuggestions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GeoSuggestions', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken', protoName: 'sessionToken')
    ..pc<$0.GeoSuggestion>(2, _omitFieldNames ? '' : 'result', $pb.PbFieldType.PM, subBuilder: $0.GeoSuggestion.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeoSuggestions clone() => GeoSuggestions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeoSuggestions copyWith(void Function(GeoSuggestions) updates) => super.copyWith((message) => updates(message as GeoSuggestions)) as GeoSuggestions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeoSuggestions create() => GeoSuggestions._();
  GeoSuggestions createEmptyInstance() => create();
  static $pb.PbList<GeoSuggestions> createRepeated() => $pb.PbList<GeoSuggestions>();
  @$core.pragma('dart2js:noInline')
  static GeoSuggestions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoSuggestions>(create);
  static GeoSuggestions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$0.GeoSuggestion> get result => $_getList(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
