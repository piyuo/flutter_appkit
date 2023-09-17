//
//  Generated code. Do not modify.
//  source: login_pin_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Result is login pin result.
class LoginPinResponse_Result extends $pb.ProtobufEnum {
  static const LoginPinResponse_Result RESULT_UNSPECIFIED = LoginPinResponse_Result._(0, _omitEnumNames ? '' : 'RESULT_UNSPECIFIED');
  static const LoginPinResponse_Result RESULT_OK = LoginPinResponse_Result._(1, _omitEnumNames ? '' : 'RESULT_OK');
  static const LoginPinResponse_Result RESULT_EMAIL_NOT_EXISTS = LoginPinResponse_Result._(2, _omitEnumNames ? '' : 'RESULT_EMAIL_NOT_EXISTS');
  static const LoginPinResponse_Result RESULT_WRONG_PIN = LoginPinResponse_Result._(3, _omitEnumNames ? '' : 'RESULT_WRONG_PIN');

  static const $core.List<LoginPinResponse_Result> values = <LoginPinResponse_Result> [
    RESULT_UNSPECIFIED,
    RESULT_OK,
    RESULT_EMAIL_NOT_EXISTS,
    RESULT_WRONG_PIN,
  ];

  static final $core.Map<$core.int, LoginPinResponse_Result> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoginPinResponse_Result? valueOf($core.int value) => _byValue[value];

  const LoginPinResponse_Result._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
