///
//  Generated code. Do not modify.
//  source: cmd_signup_account.proto
//
// @dart = 2.12
// ignore_for_file: constant_identifier_names,depend_on_referenced_packages,no_leading_underscores_for_local_identifiers,unnecessary_import, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdSignupAccount extends pb.Object {
  $core.int mapIdXXX() => 1014;
  get namespace => 'auth';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdSignupAccount', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timezone')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timezoneOffset', $pb.PbFieldType.O3, protoName: 'timezoneOffset')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'verifiedToken', protoName: 'verifiedToken')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'email')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firstName', protoName: 'firstName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastName', protoName: 'lastName')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'storeName', protoName: 'storeName')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subDomain', protoName: 'subDomain')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'placeLat', $pb.PbFieldType.OD, protoName: 'placeLat')
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'placeLng', $pb.PbFieldType.OD, protoName: 'placeLng')
    ..pPS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'placeTags', protoName: 'placeTags')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'placeCountry', protoName: 'placeCountry')
    ..aOS(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'placeAddress', protoName: 'placeAddress')
    ..aOS(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'placeAddress2', protoName: 'placeAddress2')
    ..hasRequiredFields = false
  ;

  CmdSignupAccount._() : super();
  factory CmdSignupAccount({
    $core.String? timezone,
    $core.int? timezoneOffset,
    $core.String? verifiedToken,
    $core.String? email,
    $core.String? firstName,
    $core.String? lastName,
    $core.String? storeName,
    $core.String? subDomain,
    $core.double? placeLat,
    $core.double? placeLng,
    $core.Iterable<$core.String>? placeTags,
    $core.String? placeCountry,
    $core.String? placeAddress,
    $core.String? placeAddress2,
  }) {
    final _result = create();
    if (timezone != null) {
      _result.timezone = timezone;
    }
    if (timezoneOffset != null) {
      _result.timezoneOffset = timezoneOffset;
    }
    if (verifiedToken != null) {
      _result.verifiedToken = verifiedToken;
    }
    if (email != null) {
      _result.email = email;
    }
    if (firstName != null) {
      _result.firstName = firstName;
    }
    if (lastName != null) {
      _result.lastName = lastName;
    }
    if (storeName != null) {
      _result.storeName = storeName;
    }
    if (subDomain != null) {
      _result.subDomain = subDomain;
    }
    if (placeLat != null) {
      _result.placeLat = placeLat;
    }
    if (placeLng != null) {
      _result.placeLng = placeLng;
    }
    if (placeTags != null) {
      _result.placeTags.addAll(placeTags);
    }
    if (placeCountry != null) {
      _result.placeCountry = placeCountry;
    }
    if (placeAddress != null) {
      _result.placeAddress = placeAddress;
    }
    if (placeAddress2 != null) {
      _result.placeAddress2 = placeAddress2;
    }
    return _result;
  }
  factory CmdSignupAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSignupAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSignupAccount clone() => CmdSignupAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSignupAccount copyWith(void Function(CmdSignupAccount) updates) => super.copyWith((message) => updates(message as CmdSignupAccount)) as CmdSignupAccount; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CmdSignupAccount create() => CmdSignupAccount._();
  CmdSignupAccount createEmptyInstance() => create();
  static $pb.PbList<CmdSignupAccount> createRepeated() => $pb.PbList<CmdSignupAccount>();
  @$core.pragma('dart2js:noInline')
  static CmdSignupAccount getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdSignupAccount>(create);
  static CmdSignupAccount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get timezone => $_getSZ(0);
  @$pb.TagNumber(1)
  set timezone($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimezone() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimezone() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get timezoneOffset => $_getIZ(1);
  @$pb.TagNumber(2)
  set timezoneOffset($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimezoneOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimezoneOffset() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get verifiedToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set verifiedToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVerifiedToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearVerifiedToken() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get email => $_getSZ(3);
  @$pb.TagNumber(4)
  set email($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasEmail() => $_has(3);
  @$pb.TagNumber(4)
  void clearEmail() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get firstName => $_getSZ(4);
  @$pb.TagNumber(5)
  set firstName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFirstName() => $_has(4);
  @$pb.TagNumber(5)
  void clearFirstName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get lastName => $_getSZ(5);
  @$pb.TagNumber(6)
  set lastName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLastName() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastName() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get storeName => $_getSZ(6);
  @$pb.TagNumber(7)
  set storeName($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStoreName() => $_has(6);
  @$pb.TagNumber(7)
  void clearStoreName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get subDomain => $_getSZ(7);
  @$pb.TagNumber(8)
  set subDomain($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSubDomain() => $_has(7);
  @$pb.TagNumber(8)
  void clearSubDomain() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get placeLat => $_getN(8);
  @$pb.TagNumber(9)
  set placeLat($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPlaceLat() => $_has(8);
  @$pb.TagNumber(9)
  void clearPlaceLat() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get placeLng => $_getN(9);
  @$pb.TagNumber(10)
  set placeLng($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPlaceLng() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlaceLng() => clearField(10);

  @$pb.TagNumber(11)
  $core.List<$core.String> get placeTags => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get placeCountry => $_getSZ(11);
  @$pb.TagNumber(12)
  set placeCountry($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasPlaceCountry() => $_has(11);
  @$pb.TagNumber(12)
  void clearPlaceCountry() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get placeAddress => $_getSZ(12);
  @$pb.TagNumber(13)
  set placeAddress($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasPlaceAddress() => $_has(12);
  @$pb.TagNumber(13)
  void clearPlaceAddress() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get placeAddress2 => $_getSZ(13);
  @$pb.TagNumber(14)
  set placeAddress2($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasPlaceAddress2() => $_has(13);
  @$pb.TagNumber(14)
  void clearPlaceAddress2() => clearField(14);
}

