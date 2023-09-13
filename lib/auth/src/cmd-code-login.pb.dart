//
//  Generated code. Do not modify.
//  source: cmd-code-login.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do login user using email and code
///
/// 	Email is user login email
/// 	Code is user input code
/// 	IssueRefreshToken is true mean user need refresh token
///
/// 	return SessionResponse if login successfully
/// 	error "INVALID_CODE" if Code is not 6 digit number
/// 	error "INVALID_EMAIL" if Email is empty
/// 	error "CODE_MISMATCH" if code is not in verify record
/// 	error "USER_NOT_EXIST"
/// 	error "USER_LEAVE"
/// 	error "USER_CANCELED"
/// 	error "ACCOUNT_NOT_EXIST"
/// 	error "ACCOUNT_SUSPEND"
/// 	error "ACCOUNT_CANCELED"
/// 	error "PIN_ENTER_BLOCK_SHORT"
/// 	error "PIN_ENTER_BLOCK_LONG"
/// 	error "PIN_ENTER_BLOCK"
/// 	error "PIN_NOT_EXISTS"
class CmdCodeLogin extends net.Object {
  $core.int mapIdXXX() => 1002;
  get namespace => 'auth';

  factory CmdCodeLogin({
    $core.String? email,
    $core.String? code,
    $core.bool? issueRefreshToken,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (code != null) {
      $result.code = code;
    }
    if (issueRefreshToken != null) {
      $result.issueRefreshToken = issueRefreshToken;
    }
    return $result;
  }
  CmdCodeLogin._() : super();
  factory CmdCodeLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdCodeLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdCodeLogin', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOB(3, _omitFieldNames ? '' : 'issueRefreshToken', protoName: 'issueRefreshToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdCodeLogin clone() => CmdCodeLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdCodeLogin copyWith(void Function(CmdCodeLogin) updates) => super.copyWith((message) => updates(message as CmdCodeLogin)) as CmdCodeLogin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdCodeLogin create() => CmdCodeLogin._();
  CmdCodeLogin createEmptyInstance() => create();
  static $pb.PbList<CmdCodeLogin> createRepeated() => $pb.PbList<CmdCodeLogin>();
  @$core.pragma('dart2js:noInline')
  static CmdCodeLogin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdCodeLogin>(create);
  static CmdCodeLogin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get issueRefreshToken => $_getBF(2);
  @$pb.TagNumber(3)
  set issueRefreshToken($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIssueRefreshToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssueRefreshToken() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
