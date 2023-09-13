//
//  Generated code. Do not modify.
//  source: cmd-auto-complete.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do use user input text to return suggestion
///
/// 	sessionToken {string} user input session
/// 	input {string} user input text
/// 	lat {double} user gps latitude
/// 	lng {double} user gps longitude
///
/// 	return {GeoSuggestions} is success
/// 	return INPUT_INVALID {PbError} if input is invalid
class CmdAutoComplete extends net.Object {
  $core.int mapIdXXX() => 1000;
  get namespace => 'sys';

  factory CmdAutoComplete({
    $core.String? sessionToken,
    $core.String? input,
    $core.double? lat,
    $core.double? lng,
  }) {
    final $result = create();
    if (sessionToken != null) {
      $result.sessionToken = sessionToken;
    }
    if (input != null) {
      $result.input = input;
    }
    if (lat != null) {
      $result.lat = lat;
    }
    if (lng != null) {
      $result.lng = lng;
    }
    return $result;
  }
  CmdAutoComplete._() : super();
  factory CmdAutoComplete.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdAutoComplete.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdAutoComplete', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sessionToken', protoName: 'sessionToken')
    ..aOS(2, _omitFieldNames ? '' : 'input')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'lng', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdAutoComplete clone() => CmdAutoComplete()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdAutoComplete copyWith(void Function(CmdAutoComplete) updates) => super.copyWith((message) => updates(message as CmdAutoComplete)) as CmdAutoComplete;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdAutoComplete create() => CmdAutoComplete._();
  CmdAutoComplete createEmptyInstance() => create();
  static $pb.PbList<CmdAutoComplete> createRepeated() => $pb.PbList<CmdAutoComplete>();
  @$core.pragma('dart2js:noInline')
  static CmdAutoComplete getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdAutoComplete>(create);
  static CmdAutoComplete? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get input => $_getSZ(1);
  @$pb.TagNumber(2)
  set input($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInput() => $_has(1);
  @$pb.TagNumber(2)
  void clearInput() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get lat => $_getN(2);
  @$pb.TagNumber(3)
  set lat($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLat() => $_has(2);
  @$pb.TagNumber(3)
  void clearLat() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get lng => $_getN(3);
  @$pb.TagNumber(4)
  set lng($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLng() => $_has(3);
  @$pb.TagNumber(4)
  void clearLng() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
