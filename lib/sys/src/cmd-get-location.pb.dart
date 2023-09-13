//
//  Generated code. Do not modify.
//  source: cmd-get-location.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do get location from suggestion id
///
/// 	sessionToken {string} a unique string to identify session, usually UUID
/// 	suggestionID {string} id from geo suggestion
///
/// 	return {GeoLocation} is success
/// 	return NOT_FOUND {PbError} if location can not be found
class CmdGetLocation extends net.Object {
  $core.int mapIdXXX() => 1001;
  get namespace => 'sys';

  factory CmdGetLocation({
    $core.String? sessionToken,
    $core.String? suggestionID,
  }) {
    final $result = create();
    if (sessionToken != null) {
      $result.sessionToken = sessionToken;
    }
    if (suggestionID != null) {
      $result.suggestionID = suggestionID;
    }
    return $result;
  }
  CmdGetLocation._() : super();
  factory CmdGetLocation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdGetLocation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdGetLocation', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken', protoName: 'sessionToken')
    ..aOS(2, _omitFieldNames ? '' : 'suggestionID', protoName: 'suggestionID')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdGetLocation clone() => CmdGetLocation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdGetLocation copyWith(void Function(CmdGetLocation) updates) => super.copyWith((message) => updates(message as CmdGetLocation)) as CmdGetLocation;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
