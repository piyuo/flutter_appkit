///
//  Generated code. Do not modify.
//  source: cmd-google-login.proto
//
// @dart = 2.12
// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdGoogleLogin extends pb.Object {
  $core.int mapIdXXX() => 1004;
  get namespace => 'auth';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdGoogleLogin', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'googleAccessToken', protoName: 'googleAccessToken')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'issueRefreshToken', protoName: 'issueRefreshToken')
    ..hasRequiredFields = false
  ;

  CmdGoogleLogin._() : super();
  factory CmdGoogleLogin({
    $core.String? googleAccessToken,
    $core.bool? issueRefreshToken,
  }) {
    final _result = create();
    if (googleAccessToken != null) {
      _result.googleAccessToken = googleAccessToken;
    }
    if (issueRefreshToken != null) {
      _result.issueRefreshToken = issueRefreshToken;
    }
    return _result;
  }
  factory CmdGoogleLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdGoogleLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdGoogleLogin clone() => CmdGoogleLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdGoogleLogin copyWith(void Function(CmdGoogleLogin) updates) => super.copyWith((message) => updates(message as CmdGoogleLogin)) as CmdGoogleLogin; // ignore: deprecated_member_use
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

