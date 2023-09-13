//
//  Generated code. Do not modify.
//  source: cmd-google-login.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do login user using google access token
///
/// 	GoogleAccessToken is access token issue by google
/// 	IssueRefreshToken is true mean user need refresh token
///
/// 	return LoginResponse if login successfully
/// 	error "INVALID_TOKEN"
/// 	error "TOKEN_EXPIRED"
/// 	error "EMAIL_NOT_EXIST"
/// 	error "USER_NOT_EXIST"
/// 	error "STORE_NOT_EXIST"
/// 	error "ACCOUNT_SUSPEND"
/// 	error "ACCOUNT_CANCELED"
/// 	error "USER_LEAVE"
/// 	error "USER_CANCELED"
class CmdGoogleLogin extends net.Object {
  $core.int mapIdXXX() => 1004;
  get namespace => 'auth';

  factory CmdGoogleLogin({
    $core.String? googleAccessToken,
    $core.bool? issueRefreshToken,
  }) {
    final $result = create();
    if (googleAccessToken != null) {
      $result.googleAccessToken = googleAccessToken;
    }
    if (issueRefreshToken != null) {
      $result.issueRefreshToken = issueRefreshToken;
    }
    return $result;
  }
  CmdGoogleLogin._() : super();
  factory CmdGoogleLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdGoogleLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdGoogleLogin', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'googleAccessToken', protoName: 'googleAccessToken')
    ..aOB(2, _omitFieldNames ? '' : 'issueRefreshToken', protoName: 'issueRefreshToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdGoogleLogin clone() => CmdGoogleLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdGoogleLogin copyWith(void Function(CmdGoogleLogin) updates) => super.copyWith((message) => updates(message as CmdGoogleLogin)) as CmdGoogleLogin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdGoogleLogin create() => CmdGoogleLogin._();
  CmdGoogleLogin createEmptyInstance() => create();
  static $pb.PbList<CmdGoogleLogin> createRepeated() => $pb.PbList<CmdGoogleLogin>();
  @$core.pragma('dart2js:noInline')
  static CmdGoogleLogin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdGoogleLogin>(create);
  static CmdGoogleLogin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get googleAccessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set googleAccessToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGoogleAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoogleAccessToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get issueRefreshToken => $_getBF(1);
  @$pb.TagNumber(2)
  set issueRefreshToken($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIssueRefreshToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearIssueRefreshToken() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
