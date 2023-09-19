//
//  Generated code. Do not modify.
//  source: send_pin_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Result is email sending result.
class SendPinResponse_Result extends $pb.ProtobufEnum {
  static const SendPinResponse_Result RESULT_UNSPECIFIED = SendPinResponse_Result._(0, _omitEnumNames ? '' : 'RESULT_UNSPECIFIED');
  static const SendPinResponse_Result RESULT_OK = SendPinResponse_Result._(1, _omitEnumNames ? '' : 'RESULT_OK');
  static const SendPinResponse_Result RESULT_EMAIL_INVALID = SendPinResponse_Result._(2, _omitEnumNames ? '' : 'RESULT_EMAIL_INVALID');
  static const SendPinResponse_Result RESULT_EMAIL_REJECT = SendPinResponse_Result._(3, _omitEnumNames ? '' : 'RESULT_EMAIL_REJECT');

  static const $core.List<SendPinResponse_Result> values = <SendPinResponse_Result> [
    RESULT_UNSPECIFIED,
    RESULT_OK,
    RESULT_EMAIL_INVALID,
    RESULT_EMAIL_REJECT,
  ];

  static final $core.Map<$core.int, SendPinResponse_Result> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SendPinResponse_Result? valueOf($core.int value) => _byValue[value];

  const SendPinResponse_Result._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
