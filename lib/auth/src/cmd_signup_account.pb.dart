//
//  Generated code. Do not modify.
//  source: cmd_signup_account.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do create account using verified encrypted token
///
///   timezone {string} user current timezone
///   timezoneOffset {int32} user current timezone offset
/// 	verifiedToken {string} code verification token
/// 	email {string} account email
/// 	firstName {string} account owner First name
/// 	lastName {string} account owner Last name
/// 	storeName {string} account store name
/// 	subDomain {string} account selected sub domain name and it is unique
/// 	placeLat {double} is user enter place latitude
/// 	placeLng {double} is user enter place longitude
/// 	placeTags {[]string} is user enter place tags
/// 	placeCountry {string} is user enter place country
/// 	placeAddress {string} is user enter place address
/// 	placeAddress2 {string} is user enter place second line
///
/// 	return {Session} if success
/// 	return TOKEN_INVALID {PbError} if encrypted token is invalid
/// 	return STORE_EMPTY {PbError} if store name is empty
/// 	return SUBDOMAIN_TAKEN {PbError} if sub domain is taken
/// 	return EMAIL_TAKEN {PbError} if email is taken
class CmdSignupAccount extends net.Object {
  $core.int mapIdXXX() => 1022;
  get namespace => 'auth';

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
    final $result = create();
    if (timezone != null) {
      $result.timezone = timezone;
    }
    if (timezoneOffset != null) {
      $result.timezoneOffset = timezoneOffset;
    }
    if (verifiedToken != null) {
      $result.verifiedToken = verifiedToken;
    }
    if (email != null) {
      $result.email = email;
    }
    if (firstName != null) {
      $result.firstName = firstName;
    }
    if (lastName != null) {
      $result.lastName = lastName;
    }
    if (storeName != null) {
      $result.storeName = storeName;
    }
    if (subDomain != null) {
      $result.subDomain = subDomain;
    }
    if (placeLat != null) {
      $result.placeLat = placeLat;
    }
    if (placeLng != null) {
      $result.placeLng = placeLng;
    }
    if (placeTags != null) {
      $result.placeTags.addAll(placeTags);
    }
    if (placeCountry != null) {
      $result.placeCountry = placeCountry;
    }
    if (placeAddress != null) {
      $result.placeAddress = placeAddress;
    }
    if (placeAddress2 != null) {
      $result.placeAddress2 = placeAddress2;
    }
    return $result;
  }
  CmdSignupAccount._() : super();
  factory CmdSignupAccount.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSignupAccount.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdSignupAccount', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'timezone')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'timezoneOffset', $pb.PbFieldType.O3, protoName: 'timezoneOffset')
    ..aOS(3, _omitFieldNames ? '' : 'verifiedToken', protoName: 'verifiedToken')
    ..aOS(4, _omitFieldNames ? '' : 'email')
    ..aOS(5, _omitFieldNames ? '' : 'firstName', protoName: 'firstName')
    ..aOS(6, _omitFieldNames ? '' : 'lastName', protoName: 'lastName')
    ..aOS(7, _omitFieldNames ? '' : 'storeName', protoName: 'storeName')
    ..aOS(8, _omitFieldNames ? '' : 'subDomain', protoName: 'subDomain')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'placeLat', $pb.PbFieldType.OD, protoName: 'placeLat')
    ..a<$core.double>(10, _omitFieldNames ? '' : 'placeLng', $pb.PbFieldType.OD, protoName: 'placeLng')
    ..pPS(11, _omitFieldNames ? '' : 'placeTags', protoName: 'placeTags')
    ..aOS(12, _omitFieldNames ? '' : 'placeCountry', protoName: 'placeCountry')
    ..aOS(13, _omitFieldNames ? '' : 'placeAddress', protoName: 'placeAddress')
    ..aOS(14, _omitFieldNames ? '' : 'placeAddress2', protoName: 'placeAddress2')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSignupAccount clone() => CmdSignupAccount()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSignupAccount copyWith(void Function(CmdSignupAccount) updates) => super.copyWith((message) => updates(message as CmdSignupAccount)) as CmdSignupAccount;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
