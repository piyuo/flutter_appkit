//
//  Generated code. Do not modify.
//  source: access.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

import 'access.pbenum.dart';
// ignore: implementation_imports
import 'package:libcli/google/src/timestamp.pb.dart' as $0;

export 'access.pbenum.dart';

/// Access is result of login
class Access extends net.Object {
  $core.int mapIdXXX() => 1016;
  get namespace => 'auth';
  setAccessToken(token) => accessToken = token;
  get accessTokenRequired => true;

  factory Access({
    Access_State? state,
    Access_Region? region,
    $core.String? accessToken,
    $0.Timestamp? accessExpire,
    $core.String? refreshToken,
    $0.Timestamp? refreshExpired,
    $core.Map<$core.String, $core.String>? args,
  }) {
    final $result = create();
    if (state != null) {
      $result.state = state;
    }
    if (region != null) {
      $result.region = region;
    }
    if (accessToken != null) {
      $result.accessToken = accessToken;
    }
    if (accessExpire != null) {
      $result.accessExpire = accessExpire;
    }
    if (refreshToken != null) {
      $result.refreshToken = refreshToken;
    }
    if (refreshExpired != null) {
      $result.refreshExpired = refreshExpired;
    }
    if (args != null) {
      $result.args.addAll(args);
    }
    return $result;
  }
  Access._() : super();
  factory Access.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Access.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Access', createEmptyInstance: create)
    ..e<Access_State>(1, _omitFieldNames ? '' : 'state', $pb.PbFieldType.OE, defaultOrMaker: Access_State.STATE_UNSPECIFIED, valueOf: Access_State.valueOf, enumValues: Access_State.values)
    ..e<Access_Region>(2, _omitFieldNames ? '' : 'region', $pb.PbFieldType.OE, defaultOrMaker: Access_Region.REGION_UNSPECIFIED, valueOf: Access_Region.valueOf, enumValues: Access_Region.values)
    ..aOS(3, _omitFieldNames ? '' : 'accessToken')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'accessExpire', subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'refreshToken')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'refreshExpired', subBuilder: $0.Timestamp.create)
    ..m<$core.String, $core.String>(7, _omitFieldNames ? '' : 'args', entryClassName: 'Access.ArgsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Access clone() => Access()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Access copyWith(void Function(Access) updates) => super.copyWith((message) => updates(message as Access)) as Access;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Access create() => Access._();
  Access createEmptyInstance() => create();
  static $pb.PbList<Access> createRepeated() => $pb.PbList<Access>();
  @$core.pragma('dart2js:noInline')
  static Access getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Access>(create);
  static Access? _defaultInstance;

  /// state is state of this access
  @$pb.TagNumber(1)
  Access_State get state => $_getN(0);
  @$pb.TagNumber(1)
  set state(Access_State v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => clearField(1);

  /// region is region of user
  @$pb.TagNumber(2)
  Access_Region get region => $_getN(1);
  @$pb.TagNumber(2)
  set region(Access_Region v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRegion() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegion() => clearField(2);

  /// access_token is access token
  @$pb.TagNumber(3)
  $core.String get accessToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set accessToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccessToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccessToken() => clearField(3);

  /// access_expire is access token expired time
  @$pb.TagNumber(4)
  $0.Timestamp get accessExpire => $_getN(3);
  @$pb.TagNumber(4)
  set accessExpire($0.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAccessExpire() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccessExpire() => clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureAccessExpire() => $_ensure(3);

  /// refresh_token is refresh token
  @$pb.TagNumber(5)
  $core.String get refreshToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set refreshToken($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRefreshToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefreshToken() => clearField(5);

  /// refresh_expired is refresh token expired time
  @$pb.TagNumber(6)
  $0.Timestamp get refreshExpired => $_getN(5);
  @$pb.TagNumber(6)
  set refreshExpired($0.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasRefreshExpired() => $_has(5);
  @$pb.TagNumber(6)
  void clearRefreshExpired() => clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureRefreshExpired() => $_ensure(5);

  /// args is extra arguments
  @$pb.TagNumber(7)
  $core.Map<$core.String, $core.String> get args => $_getMap(6);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
