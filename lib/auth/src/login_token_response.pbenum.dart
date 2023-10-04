//
//  Generated code. Do not modify.
//  source: login_token_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Result is login pin result.
class LoginTokenResponse_Result extends $pb.ProtobufEnum {
  static const LoginTokenResponse_Result RESULT_UNSPECIFIED = LoginTokenResponse_Result._(0, _omitEnumNames ? '' : 'RESULT_UNSPECIFIED');
  static const LoginTokenResponse_Result RESULT_OK = LoginTokenResponse_Result._(1, _omitEnumNames ? '' : 'RESULT_OK');
  static const LoginTokenResponse_Result RESULT_INVALID = LoginTokenResponse_Result._(2, _omitEnumNames ? '' : 'RESULT_INVALID');

  static const $core.List<LoginTokenResponse_Result> values = <LoginTokenResponse_Result> [
    RESULT_UNSPECIFIED,
    RESULT_OK,
    RESULT_INVALID,
  ];

  static final $core.Map<$core.int, LoginTokenResponse_Result> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoginTokenResponse_Result? valueOf($core.int value) => _byValue[value];

  const LoginTokenResponse_Result._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
