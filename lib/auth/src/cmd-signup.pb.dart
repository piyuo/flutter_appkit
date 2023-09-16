//
//  Generated code. Do not modify.
//  source: cmd-signup.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do check email can sign up account and send verification code to the email
///  address
///
/// 	Email {string} this email to create account
///
/// 	return {PbOK} if account can be create
/// 	return EMAIL_INVALID {PbError} if email is invalid
/// 	return EMAIL_TAKEN {PbError} if email already registered
/// 	return BLOCK_SHORT {PbError} if email is blocked by short period
/// 	return BLOCK_LONG {PbError} if email is blocked by long period
class CmdSignup extends net.Object {
  $core.int mapIdXXX() => 1024;
  get namespace => 'auth';

  factory CmdSignup({
    $core.String? email,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  CmdSignup._() : super();
  factory CmdSignup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSignup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdSignup', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSignup clone() => CmdSignup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSignup copyWith(void Function(CmdSignup) updates) => super.copyWith((message) => updates(message as CmdSignup)) as CmdSignup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdSignup create() => CmdSignup._();
  CmdSignup createEmptyInstance() => create();
  static $pb.PbList<CmdSignup> createRepeated() => $pb.PbList<CmdSignup>();
  @$core.pragma('dart2js:noInline')
  static CmdSignup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdSignup>(create);
  static CmdSignup? _defaultInstance;

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
