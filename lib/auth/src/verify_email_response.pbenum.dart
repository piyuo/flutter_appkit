//
//  Generated code. Do not modify.
//  source: verify_email_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Result is email sending result.
class VerifyEmailResponse_Result extends $pb.ProtobufEnum {
  static const VerifyEmailResponse_Result RESULT_UNSPECIFIED = VerifyEmailResponse_Result._(0, _omitEnumNames ? '' : 'RESULT_UNSPECIFIED');
  static const VerifyEmailResponse_Result RESULT_OK = VerifyEmailResponse_Result._(1, _omitEnumNames ? '' : 'RESULT_OK');
  static const VerifyEmailResponse_Result RESULT_EMAIL_INVALID = VerifyEmailResponse_Result._(2, _omitEnumNames ? '' : 'RESULT_EMAIL_INVALID');
  static const VerifyEmailResponse_Result RESULT_TRY_TOO_MANY = VerifyEmailResponse_Result._(3, _omitEnumNames ? '' : 'RESULT_TRY_TOO_MANY');
  static const VerifyEmailResponse_Result RESULT_EMAIL_REJECT = VerifyEmailResponse_Result._(4, _omitEnumNames ? '' : 'RESULT_EMAIL_REJECT');

  static const $core.List<VerifyEmailResponse_Result> values = <VerifyEmailResponse_Result> [
    RESULT_UNSPECIFIED,
    RESULT_OK,
    RESULT_EMAIL_INVALID,
    RESULT_TRY_TOO_MANY,
    RESULT_EMAIL_REJECT,
  ];

  static final $core.Map<$core.int, VerifyEmailResponse_Result> _byValue = $pb.ProtobufEnum.initByValue(values);
  static VerifyEmailResponse_Result? valueOf($core.int value) => _byValue[value];

  const VerifyEmailResponse_Result._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
