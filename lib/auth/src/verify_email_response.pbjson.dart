//
//  Generated code. Do not modify.
//  source: verify_email_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use verifyEmailResponseDescriptor instead')
const VerifyEmailResponse$json = {
  '1': 'VerifyEmailResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 14, '6': '.VerifyEmailResponse.Result', '10': 'result'},
  ],
  '4': [VerifyEmailResponse_Result$json],
};

@$core.Deprecated('Use verifyEmailResponseDescriptor instead')
const VerifyEmailResponse_Result$json = {
  '1': 'Result',
  '2': [
    {'1': 'RESULT_UNSPECIFIED', '2': 0},
    {'1': 'RESULT_OK', '2': 1},
    {'1': 'RESULT_EMAIL_INVALID', '2': 2},
    {'1': 'RESULT_EMAIL_REJECT', '2': 3},
  ],
};

/// Descriptor for `VerifyEmailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyEmailResponseDescriptor = $convert.base64Decode(
    'ChNWZXJpZnlFbWFpbFJlc3BvbnNlEjMKBnJlc3VsdBgBIAEoDjIbLlZlcmlmeUVtYWlsUmVzcG'
    '9uc2UuUmVzdWx0UgZyZXN1bHQiYgoGUmVzdWx0EhYKElJFU1VMVF9VTlNQRUNJRklFRBAAEg0K'
    'CVJFU1VMVF9PSxABEhgKFFJFU1VMVF9FTUFJTF9JTlZBTElEEAISFwoTUkVTVUxUX0VNQUlMX1'
    'JFSkVDVBAD');

