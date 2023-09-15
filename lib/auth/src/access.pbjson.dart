//
//  Generated code. Do not modify.
//  source: access.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use accessDescriptor instead')
const Access$json = {
  '1': 'Access',
  '2': [
    {'1': 'state', '3': 1, '4': 1, '5': 14, '6': '.Access.State', '10': 'state'},
    {'1': 'region', '3': 2, '4': 1, '5': 14, '6': '.Access.Region', '10': 'region'},
    {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.Access.Type', '10': 'type'},
    {'1': 'access_token', '3': 4, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'access_expire', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'accessExpire'},
    {'1': 'refresh_token', '3': 6, '4': 1, '5': 9, '10': 'refreshToken'},
    {'1': 'refresh_expired', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'refreshExpired'},
  ],
  '4': [Access_State$json, Access_Region$json, Access_Type$json],
};

@$core.Deprecated('Use accessDescriptor instead')
const Access_State$json = {
  '1': 'State',
  '2': [
    {'1': 'STATE_UNSPECIFIED', '2': 0},
    {'1': 'STATE_OK', '2': 1},
    {'1': 'STATE_SUSPEND', '2': 2},
    {'1': 'STATE_BAND', '2': 3},
  ],
};

@$core.Deprecated('Use accessDescriptor instead')
const Access_Region$json = {
  '1': 'Region',
  '2': [
    {'1': 'REGION_UNSPECIFIED', '2': 0},
    {'1': 'REGION_TW', '2': 1},
  ],
};

@$core.Deprecated('Use accessDescriptor instead')
const Access_Type$json = {
  '1': 'Type',
  '2': [
    {'1': 'TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TYPE_USER', '2': 1},
    {'1': 'TYPE_STAFF', '2': 2},
    {'1': 'TYPE_OWNER', '2': 3},
  ],
};

/// Descriptor for `Access`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accessDescriptor = $convert.base64Decode(
    'CgZBY2Nlc3MSIwoFc3RhdGUYASABKA4yDS5BY2Nlc3MuU3RhdGVSBXN0YXRlEiYKBnJlZ2lvbh'
    'gCIAEoDjIOLkFjY2Vzcy5SZWdpb25SBnJlZ2lvbhIgCgR0eXBlGAMgASgOMgwuQWNjZXNzLlR5'
    'cGVSBHR5cGUSIQoMYWNjZXNzX3Rva2VuGAQgASgJUgthY2Nlc3NUb2tlbhI/Cg1hY2Nlc3NfZX'
    'hwaXJlGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMYWNjZXNzRXhwaXJlEiMK'
    'DXJlZnJlc2hfdG9rZW4YBiABKAlSDHJlZnJlc2hUb2tlbhJDCg9yZWZyZXNoX2V4cGlyZWQYBy'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5yZWZyZXNoRXhwaXJlZCJPCgVTdGF0'
    'ZRIVChFTVEFURV9VTlNQRUNJRklFRBAAEgwKCFNUQVRFX09LEAESEQoNU1RBVEVfU1VTUEVORB'
    'ACEg4KClNUQVRFX0JBTkQQAyIvCgZSZWdpb24SFgoSUkVHSU9OX1VOU1BFQ0lGSUVEEAASDQoJ'
    'UkVHSU9OX1RXEAEiSwoEVHlwZRIUChBUWVBFX1VOU1BFQ0lGSUVEEAASDQoJVFlQRV9VU0VSEA'
    'ESDgoKVFlQRV9TVEFGRhACEg4KClRZUEVfT1dORVIQAw==');

