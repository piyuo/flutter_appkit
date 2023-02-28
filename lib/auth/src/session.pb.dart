///
//  Generated code. Do not modify.
//  source: session.proto
//
// @dart = 2.12
// ignore_for_file: constant_identifier_names,depend_on_referenced_packages,no_leading_underscores_for_local_identifiers,unnecessary_import, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

// ignore: implementation_imports
import 'package:libcli/google/src/timestamp.pb.dart' as $0;

import 'session.pbenum.dart';

export 'session.pbenum.dart';

class Session extends pb.Object {
  $core.int mapIdXXX() => 1011;
  get namespace => 'auth';
  setAccessToken(token) => accessToken = token;
  get accessTokenRequired => true;

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Session', createEmptyInstance: create)
    ..e<Session_AccountStatus>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: Session_AccountStatus.AccountNormal, valueOf: Session_AccountStatus.valueOf, enumValues: Session_AccountStatus.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'region')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessToken', protoName: 'accessToken')
    ..aOM<$0.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accessExpired', protoName: 'accessExpired', subBuilder: $0.Timestamp.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refreshToken', protoName: 'refreshToken')
    ..aOM<$0.Timestamp>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refreshExpired', protoName: 'refreshExpired', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'userType', $pb.PbFieldType.O3, protoName: 'userType')
    ..m<$core.String, $core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storeRoles', protoName: 'storeRoles', entryClassName: 'Session.StoreRolesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.O3)
    ..m<$core.String, $core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'locationRoles', protoName: 'locationRoles', entryClassName: 'Session.LocationRolesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Session._() : super();
  factory Session({
    Session_AccountStatus? status,
    $core.String? region,
    $core.String? accessToken,
    $0.Timestamp? accessExpired,
    $core.String? refreshToken,
    $0.Timestamp? refreshExpired,
    $core.int? userType,
    $core.Map<$core.String, $core.int>? storeRoles,
    $core.Map<$core.String, $core.int>? locationRoles,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (region != null) {
      _result.region = region;
    }
    if (accessToken != null) {
      _result.accessToken = accessToken;
    }
    if (accessExpired != null) {
      _result.accessExpired = accessExpired;
    }
    if (refreshToken != null) {
      _result.refreshToken = refreshToken;
    }
    if (refreshExpired != null) {
      _result.refreshExpired = refreshExpired;
    }
    if (userType != null) {
      _result.userType = userType;
    }
    if (storeRoles != null) {
      _result.storeRoles.addAll(storeRoles);
    }
    if (locationRoles != null) {
      _result.locationRoles.addAll(locationRoles);
    }
    return _result;
  }
  factory Session.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Session.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Session clone() => Session()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Session copyWith(void Function(Session) updates) => super.copyWith((message) => updates(message as Session)) as Session; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Session create() => Session._();
  Session createEmptyInstance() => create();
  static $pb.PbList<Session> createRepeated() => $pb.PbList<Session>();
  @$core.pragma('dart2js:noInline')
  static Session getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Session>(create);
  static Session? _defaultInstance;

  @$pb.TagNumber(1)
  Session_AccountStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(Session_AccountStatus v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get region => $_getSZ(1);
  @$pb.TagNumber(2)
  set region($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRegion() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegion() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get accessToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set accessToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccessToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccessToken() => clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get accessExpired => $_getN(3);
  @$pb.TagNumber(4)
  set accessExpired($0.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAccessExpired() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccessExpired() => clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureAccessExpired() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get refreshToken => $_getSZ(4);
  @$pb.TagNumber(5)
  set refreshToken($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRefreshToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearRefreshToken() => clearField(5);

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

  @$pb.TagNumber(7)
  $core.int get userType => $_getIZ(6);
  @$pb.TagNumber(7)
  set userType($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasUserType() => $_has(6);
  @$pb.TagNumber(7)
  void clearUserType() => clearField(7);

  @$pb.TagNumber(8)
  $core.Map<$core.String, $core.int> get storeRoles => $_getMap(7);

  @$pb.TagNumber(9)
  $core.Map<$core.String, $core.int> get locationRoles => $_getMap(8);
}

