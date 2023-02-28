///
//  Generated code. Do not modify.
//  source: session.proto
//
// @dart = 2.12
// ignore_for_file: constant_identifier_names, annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use sessionDescriptor instead')
const Session$json = const {
  '1': 'Session',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.Session.AccountStatus', '10': 'status'},
    const {'1': 'region', '3': 2, '4': 1, '5': 9, '10': 'region'},
    const {'1': 'accessToken', '3': 3, '4': 1, '5': 9, '10': 'accessToken'},
    const {'1': 'accessExpired', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'accessExpired'},
    const {'1': 'refreshToken', '3': 5, '4': 1, '5': 9, '10': 'refreshToken'},
    const {'1': 'refreshExpired', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'refreshExpired'},
    const {'1': 'userType', '3': 7, '4': 1, '5': 5, '10': 'userType'},
    const {'1': 'storeRoles', '3': 8, '4': 3, '5': 11, '6': '.Session.StoreRolesEntry', '10': 'storeRoles'},
    const {'1': 'locationRoles', '3': 9, '4': 3, '5': 11, '6': '.Session.LocationRolesEntry', '10': 'locationRoles'},
  ],
  '3': const [Session_StoreRolesEntry$json, Session_LocationRolesEntry$json],
  '4': const [Session_AccountStatus$json],
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_StoreRolesEntry$json = const {
  '1': 'StoreRolesEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_LocationRolesEntry$json = const {
  '1': 'LocationRolesEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use sessionDescriptor instead')
const Session_AccountStatus$json = const {
  '1': 'AccountStatus',
  '2': const [
    const {'1': 'AccountNormal', '2': 0},
    const {'1': 'AccountSuspendSoon', '2': 1},
    const {'1': 'AccountSuspend', '2': 2},
  ],
};

/// Descriptor for `Session`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionDescriptor = $convert.base64Decode('CgdTZXNzaW9uEi4KBnN0YXR1cxgBIAEoDjIWLlNlc3Npb24uQWNjb3VudFN0YXR1c1IGc3RhdHVzEhYKBnJlZ2lvbhgCIAEoCVIGcmVnaW9uEiAKC2FjY2Vzc1Rva2VuGAMgASgJUgthY2Nlc3NUb2tlbhJACg1hY2Nlc3NFeHBpcmVkGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINYWNjZXNzRXhwaXJlZBIiCgxyZWZyZXNoVG9rZW4YBSABKAlSDHJlZnJlc2hUb2tlbhJCCg5yZWZyZXNoRXhwaXJlZBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDnJlZnJlc2hFeHBpcmVkEhoKCHVzZXJUeXBlGAcgASgFUgh1c2VyVHlwZRI4CgpzdG9yZVJvbGVzGAggAygLMhguU2Vzc2lvbi5TdG9yZVJvbGVzRW50cnlSCnN0b3JlUm9sZXMSQQoNbG9jYXRpb25Sb2xlcxgJIAMoCzIbLlNlc3Npb24uTG9jYXRpb25Sb2xlc0VudHJ5Ug1sb2NhdGlvblJvbGVzGj0KD1N0b3JlUm9sZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgBGkAKEkxvY2F0aW9uUm9sZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgBIk4KDUFjY291bnRTdGF0dXMSEQoNQWNjb3VudE5vcm1hbBAAEhYKEkFjY291bnRTdXNwZW5kU29vbhABEhIKDkFjY291bnRTdXNwZW5kEAI=');
