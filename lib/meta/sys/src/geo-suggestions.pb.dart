///
//  Generated code. Do not modify.
//  source: geo-suggestions.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

import 'geo-suggestion.pb.dart' as $0;

class GeoSuggestions extends pb.Object {
  $core.int mapIdXXX() => 1006;
  namespace() => 'sys';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GeoSuggestions', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionToken', protoName: 'sessionToken')
    ..pc<$0.GeoSuggestion>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', $pb.PbFieldType.PM, subBuilder: $0.GeoSuggestion.create)
    ..hasRequiredFields = false
  ;

  GeoSuggestions._() : super();
  factory GeoSuggestions({
    $core.String? sessionToken,
    $core.Iterable<$0.GeoSuggestion>? result,
  }) {
    final _result = create();
    if (sessionToken != null) {
      _result.sessionToken = sessionToken;
    }
    if (result != null) {
      _result.result.addAll(result);
    }
    return _result;
  }
  factory GeoSuggestions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeoSuggestions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeoSuggestions clone() => GeoSuggestions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeoSuggestions copyWith(void Function(GeoSuggestions) updates) => super.copyWith((message) => updates(message as GeoSuggestions)) as GeoSuggestions; // ignore: deprecated_member_use
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

