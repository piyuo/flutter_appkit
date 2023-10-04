//
//  Generated code. Do not modify.
//  source: login_token_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use loginTokenResponseDescriptor instead')
const LoginTokenResponse$json = {
  '1': 'LoginTokenResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 14, '6': '.LoginTokenResponse.Result', '10': 'result'},
    {'1': 'access', '3': 2, '4': 1, '5': 11, '6': '.Access', '10': 'access'},
  ],
  '4': [LoginTokenResponse_Result$json],
};

@$core.Deprecated('Use loginTokenResponseDescriptor instead')
const LoginTokenResponse_Result$json = {
  '1': 'Result',
  '2': [
    {'1': 'RESULT_UNSPECIFIED', '2': 0},
    {'1': 'RESULT_OK', '2': 1},
    {'1': 'RESULT_INVALID', '2': 2},
  ],
};

/// Descriptor for `LoginTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginTokenResponseDescriptor = $convert.base64Decode(
    'ChJMb2dpblRva2VuUmVzcG9uc2USMgoGcmVzdWx0GAEgASgOMhouTG9naW5Ub2tlblJlc3Bvbn'
    'NlLlJlc3VsdFIGcmVzdWx0Eh8KBmFjY2VzcxgCIAEoCzIHLkFjY2Vzc1IGYWNjZXNzIkMKBlJl'
    'c3VsdBIWChJSRVNVTFRfVU5TUEVDSUZJRUQQABINCglSRVNVTFRfT0sQARISCg5SRVNVTFRfSU'
    '5WQUxJRBAC');

