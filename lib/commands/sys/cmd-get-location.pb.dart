///
//  Generated code. Do not modify.
//  source: cmd-get-location.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdGetLocation extends pb.Object {
  $core.int mapIdXXX() {
    return 1002;
  }
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdGetLocation', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sessionToken', protoName: 'sessionToken')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'suggestionID', protoName: 'suggestionID')
    ..hasRequiredFields = false
  ;

  CmdGetLocation._() : super();
  factory CmdGetLocation({
    $core.String? sessionToken,
    $core.String? suggestionID,
  }) {
    final _result = create();
    if (sessionToken != null) {
      _result.sessionToken = sessionToken;
    }
    if (suggestionID != null) {
      _result.suggestionID = suggestionID;
    }
    return _result;
  }
  factory CmdGetLocation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdGetLocation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdGetLocation clone() => CmdGetLocation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdGetLocation copyWith(void Function(CmdGetLocation) updates) => super.copyWith((message) => updates(message as CmdGetLocation)) as CmdGetLocation; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CmdGetLocation create() => CmdGetLocation._();
  CmdGetLocation createEmptyInstance() => create();
  static $pb.PbList<CmdGetLocation> createRepeated() => $pb.PbList<CmdGetLocation>();
  @$core.pragma('dart2js:noInline')
  static CmdGetLocation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdGetLocation>(create);
  static CmdGetLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get suggestionID => $_getSZ(1);
  @$pb.TagNumber(2)
  set suggestionID($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSuggestionID() => $_has(1);
  @$pb.TagNumber(2)
  void clearSuggestionID() => clearField(2);
}

