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
    {'1': 'access_token', '3': 3, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'access_expire', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'accessExpire'},
    {'1': 'refresh_token', '3': 5, '4': 1, '5': 9, '10': 'refreshToken'},
    {'1': 'refresh_expire', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'refreshExpire'},
    {'1': 'args', '3': 7, '4': 3, '5': 11, '6': '.Access.ArgsEntry', '10': 'args'},
  ],
  '3': [Access_ArgsEntry$json],
  '4': [Access_State$json, Access_Region$json],
};

@$core.Deprecated('Use accessDescriptor instead')
const Access_ArgsEntry$json = {
  '1': 'ArgsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
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

/// Descriptor for `Access`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accessDescriptor = $convert.base64Decode(
    'CgZBY2Nlc3MSIwoFc3RhdGUYASABKA4yDS5BY2Nlc3MuU3RhdGVSBXN0YXRlEiYKBnJlZ2lvbh'
    'gCIAEoDjIOLkFjY2Vzcy5SZWdpb25SBnJlZ2lvbhIhCgxhY2Nlc3NfdG9rZW4YAyABKAlSC2Fj'
    'Y2Vzc1Rva2VuEj8KDWFjY2Vzc19leHBpcmUYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgxhY2Nlc3NFeHBpcmUSIwoNcmVmcmVzaF90b2tlbhgFIAEoCVIMcmVmcmVzaFRva2Vu'
    'EkEKDnJlZnJlc2hfZXhwaXJlGAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINcm'
    'VmcmVzaEV4cGlyZRIlCgRhcmdzGAcgAygLMhEuQWNjZXNzLkFyZ3NFbnRyeVIEYXJncxo3CglB'
    'cmdzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4ASJPCg'
    'VTdGF0ZRIVChFTVEFURV9VTlNQRUNJRklFRBAAEgwKCFNUQVRFX09LEAESEQoNU1RBVEVfU1VT'
    'UEVORBACEg4KClNUQVRFX0JBTkQQAyIvCgZSZWdpb24SFgoSUkVHSU9OX1VOU1BFQ0lGSUVEEA'
    'ASDQoJUkVHSU9OX1RXEAE=');

