//
//  Generated code. Do not modify.
//  source: cmd-resend-code.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do re-send verification code to email
///
/// 	Email {string} email address to resend the code
///
/// 	return {PbOK} if success
/// 	return EMAIL_INVALID {PbError} if email is invalid
/// 	return NO_CODE {PbError} if code is never create for this email
class CmdResendCode extends net.Object {
  $core.int mapIdXXX() => 1005;
  get namespace => 'auth';

  factory CmdResendCode({
    $core.String? email,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  CmdResendCode._() : super();
  factory CmdResendCode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdResendCode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdResendCode', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdResendCode clone() => CmdResendCode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdResendCode copyWith(void Function(CmdResendCode) updates) => super.copyWith((message) => updates(message as CmdResendCode)) as CmdResendCode;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdResendCode create() => CmdResendCode._();
  CmdResendCode createEmptyInstance() => create();
  static $pb.PbList<CmdResendCode> createRepeated() => $pb.PbList<CmdResendCode>();
  @$core.pragma('dart2js:noInline')
  static CmdResendCode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdResendCode>(create);
  static CmdResendCode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
