//
//  Generated code. Do not modify.
//  source: cmd_signup_verify.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do check user input code match with the code we email
///
/// 	Email {string} we send code to this email
/// 	Code {string} the code user input
///
/// 	return {PbString} send encrypted token that need for create account if code is verified
/// 	return EMAIL_INVALID {PbError} if email is empty
/// 	return CODE_INVALID {PbError} if code is not 6 digit number
/// 	return CODE_MISMATCH {PbError} if user input code is not match with our record
/// 	return NO_CODE {PbError} our pin record maybe expired
/// 	return BLOCK_SHORT {PbError} if email is blocked by short period
/// 	return BLOCK_LONG {PbError} if email is blocked by long period
class CmdSignupVerify extends net.Object {
  $core.int mapIdXXX() => 1015;
  get namespace => 'auth';

  factory CmdSignupVerify({
    $core.String? email,
    $core.String? code,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (code != null) {
      $result.code = code;
    }
    return $result;
  }
  CmdSignupVerify._() : super();
  factory CmdSignupVerify.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSignupVerify.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdSignupVerify', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSignupVerify clone() => CmdSignupVerify()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSignupVerify copyWith(void Function(CmdSignupVerify) updates) => super.copyWith((message) => updates(message as CmdSignupVerify)) as CmdSignupVerify;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdSignupVerify create() => CmdSignupVerify._();
  CmdSignupVerify createEmptyInstance() => create();
  static $pb.PbList<CmdSignupVerify> createRepeated() => $pb.PbList<CmdSignupVerify>();
  @$core.pragma('dart2js:noInline')
  static CmdSignupVerify getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdSignupVerify>(create);
  static CmdSignupVerify? _defaultInstance;

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
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
