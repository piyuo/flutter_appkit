//
//  Generated code. Do not modify.
//  source: login_token_response.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

import 'access.pb.dart' as $0;
import 'login_token_response.pbenum.dart';

export 'login_token_response.pbenum.dart';

class LoginTokenResponse extends net.Object {
  $core.int mapIdXXX() => 1033;
  get namespace => 'auth';

  factory LoginTokenResponse({
    LoginTokenResponse_Result? result,
    $0.Access? access,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    if (access != null) {
      $result.access = access;
    }
    return $result;
  }
  LoginTokenResponse._() : super();
  factory LoginTokenResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginTokenResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginTokenResponse', createEmptyInstance: create)
    ..e<LoginTokenResponse_Result>(1, _omitFieldNames ? '' : 'result', $pb.PbFieldType.OE, defaultOrMaker: LoginTokenResponse_Result.RESULT_UNSPECIFIED, valueOf: LoginTokenResponse_Result.valueOf, enumValues: LoginTokenResponse_Result.values)
    ..aOM<$0.Access>(2, _omitFieldNames ? '' : 'access', subBuilder: $0.Access.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginTokenResponse clone() => LoginTokenResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginTokenResponse copyWith(void Function(LoginTokenResponse) updates) => super.copyWith((message) => updates(message as LoginTokenResponse)) as LoginTokenResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginTokenResponse create() => LoginTokenResponse._();
  LoginTokenResponse createEmptyInstance() => create();
  static $pb.PbList<LoginTokenResponse> createRepeated() => $pb.PbList<LoginTokenResponse>();
  @$core.pragma('dart2js:noInline')
  static LoginTokenResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginTokenResponse>(create);
  static LoginTokenResponse? _defaultInstance;

  /// Result is login pin result.
  @$pb.TagNumber(1)
  LoginTokenResponse_Result get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(LoginTokenResponse_Result v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);

  /// if result is RESULT_OK, then access will have access information.
  @$pb.TagNumber(2)
  $0.Access get access => $_getN(1);
  @$pb.TagNumber(2)
  set access($0.Access v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccess() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccess() => clearField(2);
  @$pb.TagNumber(2)
  $0.Access ensureAccess() => $_ensure(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
