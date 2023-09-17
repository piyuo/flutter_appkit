//
//  Generated code. Do not modify.
//  source: login_pin_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use loginPinResponseDescriptor instead')
const LoginPinResponse$json = {
  '1': 'LoginPinResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 14, '6': '.LoginPinResponse.Result', '10': 'result'},
    {'1': 'access', '3': 2, '4': 1, '5': 11, '6': '.Access', '10': 'access'},
  ],
  '4': [LoginPinResponse_Result$json],
};

@$core.Deprecated('Use loginPinResponseDescriptor instead')
const LoginPinResponse_Result$json = {
  '1': 'Result',
  '2': [
    {'1': 'RESULT_UNSPECIFIED', '2': 0},
    {'1': 'RESULT_OK', '2': 1},
    {'1': 'RESULT_EMAIL_NOT_EXISTS', '2': 2},
    {'1': 'RESULT_WRONG_PIN', '2': 3},
  ],
};

/// Descriptor for `LoginPinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginPinResponseDescriptor = $convert.base64Decode(
    'ChBMb2dpblBpblJlc3BvbnNlEjAKBnJlc3VsdBgBIAEoDjIYLkxvZ2luUGluUmVzcG9uc2UuUm'
    'VzdWx0UgZyZXN1bHQSHwoGYWNjZXNzGAIgASgLMgcuQWNjZXNzUgZhY2Nlc3MiYgoGUmVzdWx0'
    'EhYKElJFU1VMVF9VTlNQRUNJRklFRBAAEg0KCVJFU1VMVF9PSxABEhsKF1JFU1VMVF9FTUFJTF'
    '9OT1RfRVhJU1RTEAISFAoQUkVTVUxUX1dST05HX1BJThAD');

