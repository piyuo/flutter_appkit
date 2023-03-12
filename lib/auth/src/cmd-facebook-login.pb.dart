///
//  Generated code. Do not modify.
//  source: cmd-facebook-login.proto
//
// @dart = 2.12
// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdFacebookLogin extends pb.Object {
  $core.int mapIdXXX() => 1003;
  get namespace => 'auth';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdFacebookLogin', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'facebookAccessToken', protoName: 'facebookAccessToken')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'issueRefreshToken', protoName: 'issueRefreshToken')
    ..hasRequiredFields = false
  ;

  CmdFacebookLogin._() : super();
  factory CmdFacebookLogin({
    $core.String? facebookAccessToken,
    $core.bool? issueRefreshToken,
  }) {
    final _result = create();
    if (facebookAccessToken != null) {
      _result.facebookAccessToken = facebookAccessToken;
    }
    if (issueRefreshToken != null) {
      _result.issueRefreshToken = issueRefreshToken;
    }
    return _result;
  }
  factory CmdFacebookLogin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdFacebookLogin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdFacebookLogin clone() => CmdFacebookLogin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdFacebookLogin copyWith(void Function(CmdFacebookLogin) updates) => super.copyWith((message) => updates(message as CmdFacebookLogin)) as CmdFacebookLogin; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CmdFacebookLogin create() => CmdFacebookLogin._();
  CmdFacebookLogin createEmptyInstance() => create();
  static $pb.PbList<CmdFacebookLogin> createRepeated() => $pb.PbList<CmdFacebookLogin>();
  @$core.pragma('dart2js:noInline')
  static CmdFacebookLogin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdFacebookLogin>(create);
  static CmdFacebookLogin? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facebookAccessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set facebookAccessToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFacebookAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacebookAccessToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get issueRefreshToken => $_getBF(1);
  @$pb.TagNumber(2)
  set issueRefreshToken($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIssueRefreshToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearIssueRefreshToken() => clearField(2);
}

