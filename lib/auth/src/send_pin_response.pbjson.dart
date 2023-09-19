//
//  Generated code. Do not modify.
//  source: send_pin_response.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sendPinResponseDescriptor instead')
const SendPinResponse$json = {
  '1': 'SendPinResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 14, '6': '.SendPinResponse.Result', '10': 'result'},
  ],
  '4': [SendPinResponse_Result$json],
};

@$core.Deprecated('Use sendPinResponseDescriptor instead')
const SendPinResponse_Result$json = {
  '1': 'Result',
  '2': [
    {'1': 'RESULT_UNSPECIFIED', '2': 0},
    {'1': 'RESULT_OK', '2': 1},
    {'1': 'RESULT_EMAIL_INVALID', '2': 2},
    {'1': 'RESULT_EMAIL_REJECT', '2': 3},
  ],
};

/// Descriptor for `SendPinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendPinResponseDescriptor = $convert.base64Decode(
    'Cg9TZW5kUGluUmVzcG9uc2USLwoGcmVzdWx0GAEgASgOMhcuU2VuZFBpblJlc3BvbnNlLlJlc3'
    'VsdFIGcmVzdWx0ImIKBlJlc3VsdBIWChJSRVNVTFRfVU5TUEVDSUZJRUQQABINCglSRVNVTFRf'
    'T0sQARIYChRSRVNVTFRfRU1BSUxfSU5WQUxJRBACEhcKE1JFU1VMVF9FTUFJTF9SRUpFQ1QQAw'
    '==');

