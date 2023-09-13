//
//  Generated code. Do not modify.
//  source: cmd-signin.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do signin by send code to email address
///
/// 	Email address to send code
///
/// 	return {PbOK} if code sent
/// 	return EMAIL_INVALID {PbError} if email is invalid
/// 	error "EMAIL_NOT_REGISTERED" {PbError} if no account link to this email
/// 	return BLOCK_SHORT {PbError} if email is blocked by short period
/// 	return BLOCK_LONG {PbError} if email is blocked by long period
class CmdSignin extends net.Object {
  $core.int mapIdXXX() => 1012;
  get namespace => 'auth';

  factory CmdSignin({
    $core.String? email,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  CmdSignin._() : super();
  factory CmdSignin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSignin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdSignin', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSignin clone() => CmdSignin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSignin copyWith(void Function(CmdSignin) updates) => super.copyWith((message) => updates(message as CmdSignin)) as CmdSignin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdSignin create() => CmdSignin._();
  CmdSignin createEmptyInstance() => create();
  static $pb.PbList<CmdSignin> createRepeated() => $pb.PbList<CmdSignin>();
  @$core.pragma('dart2js:noInline')
  static CmdSignin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdSignin>(create);
  static CmdSignin? _defaultInstance;

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
