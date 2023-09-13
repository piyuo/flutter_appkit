//
//  Generated code. Do not modify.
//  source: session.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sessionDescriptor instead')
const Session$json = {
  '1': 'Session',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.Session.AccountStatus', '10': 'status'},
    {'1': 'region', '3': 2, '4': 1, '5': 9, '10': 'region'},
    {'1': 'accessToken', '3': 3, '4': 1, '5': 9, '10': 'accessToken'},
    {'1': 'accessExpired', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'accessExpired'},
    {'1': 'refreshToken', '3': 5, '4': 1, '5': 9, '10': 'refreshToken'},
    {'1': 'refreshExpired', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'refreshExpired'},
    {'1': 'userType', '3': 7, '4': 1, '5': 5, '10': 'userType'},
    {'1': 'storeRoles', '3': 8, '4': 3, '5': 11, '6': '.Session.StoreRolesEntry', '10': 'storeRoles'},
    {'1': 'locationRoles', '3': 9, '4': 3, '5': 11, '6': '.Session.LocationRolesEntry', '10': 'locationRoles'},
  ],
  '3': [Session_StoreRolesEntry$json, Session_LocationRolesEntry$json],
  '4': [Session_AccountStatus$json],
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_StoreRolesEntry$json = {
  '1': 'StoreRolesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_LocationRolesEntry$json = {
  '1': 'LocationRolesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'AccountNormal', '2': 0},
    {'1': 'AccountSuspendSoon', '2': 1},
    {'1': 'AccountSuspend', '2': 2},
  ],
};

/// Descriptor for `Session`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionDescriptor = $convert.base64Decode(
    'CgdTZXNzaW9uEi4KBnN0YXR1cxgBIAEoDjIWLlNlc3Npb24uQWNjb3VudFN0YXR1c1IGc3RhdH'
    'VzEhYKBnJlZ2lvbhgCIAEoCVIGcmVnaW9uEiAKC2FjY2Vzc1Rva2VuGAMgASgJUgthY2Nlc3NU'
    'b2tlbhJACg1hY2Nlc3NFeHBpcmVkGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'INYWNjZXNzRXhwaXJlZBIiCgxyZWZyZXNoVG9rZW4YBSABKAlSDHJlZnJlc2hUb2tlbhJCCg5y'
    'ZWZyZXNoRXhwaXJlZBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDnJlZnJlc2'
    'hFeHBpcmVkEhoKCHVzZXJUeXBlGAcgASgFUgh1c2VyVHlwZRI4CgpzdG9yZVJvbGVzGAggAygL'
    'MhguU2Vzc2lvbi5TdG9yZVJvbGVzRW50cnlSCnN0b3JlUm9sZXMSQQoNbG9jYXRpb25Sb2xlcx'
    'gJIAMoCzIbLlNlc3Npb24uTG9jYXRpb25Sb2xlc0VudHJ5Ug1sb2NhdGlvblJvbGVzGj0KD1N0'
    'b3JlUm9sZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6Aj'
    'gBGkAKEkxvY2F0aW9uUm9sZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEo'
    'BVIFdmFsdWU6AjgBIk4KDUFjY291bnRTdGF0dXMSEQoNQWNjb3VudE5vcm1hbBAAEhYKEkFjY2'
    '91bnRTdXNwZW5kU29vbhABEhIKDkFjY291bnRTdXNwZW5kEAI=');

