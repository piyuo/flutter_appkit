///
//  Generated code. Do not modify.
//  source: cmd-code-login.proto
//
// @dart = 2.12
// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdCodeLogin extends pb.Object {
  $core.int mapIdXXX() => 1002;
  get namespace => 'auth';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdCodeLogin', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'email')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'issueRefreshToken', protoName: 'issueRefreshToken')
    ..hasRequiredFields = false
  ;

  CmdCodeLogin._() : super();
  factory CmdCodeLogin({
    $core.String? email,
    $core.String? code,
    $core.bool? issueRefreshToken,
  }) {
    final _result = create();
    if (email != null) {
      _result.email = email;
    }
    if (code != null) {
      _result.code = code;
    }
    if (issueRefreshToken != null) {
      _result.issueRefreshToken = issueRefreshToken;
    }
    return _result;
  }
  factory CmdCodeLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdCodeLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdCodeLogin clone() => CmdCodeLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdCodeLogin copyWith(void Function(CmdCodeLogin) updates) => super.copyWith((message) => updates(message as CmdCodeLogin)) as CmdCodeLogin; // ignore: deprecated_member_use
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

