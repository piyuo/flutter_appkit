///
//  Generated code. Do not modify.
//  source: cmd_signup_account.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use cmdSignupAccountDescriptor instead')
const CmdSignupAccount$json = const {
  '1': 'CmdSignupAccount',
  '2': const [
    const {'1': 'timezone', '3': 1, '4': 1, '5': 9, '10': 'timezone'},
    const {'1': 'timezoneOffset', '3': 2, '4': 1, '5': 5, '10': 'timezoneOffset'},
    const {'1': 'verifiedToken', '3': 3, '4': 1, '5': 9, '10': 'verifiedToken'},
    const {'1': 'email', '3': 4, '4': 1, '5': 9, '10': 'email'},
    const {'1': 'firstName', '3': 5, '4': 1, '5': 9, '10': 'firstName'},
    const {'1': 'lastName', '3': 6, '4': 1, '5': 9, '10': 'lastName'},
    const {'1': 'storeName', '3': 7, '4': 1, '5': 9, '10': 'storeName'},
    const {'1': 'subDomain', '3': 8, '4': 1, '5': 9, '10': 'subDomain'},
    const {'1': 'placeLat', '3': 9, '4': 1, '5': 1, '10': 'placeLat'},
    const {'1': 'placeLng', '3': 10, '4': 1, '5': 1, '10': 'placeLng'},
    const {'1': 'placeTags', '3': 11, '4': 3, '5': 9, '10': 'placeTags'},
    const {'1': 'placeCountry', '3': 12, '4': 1, '5': 9, '10': 'placeCountry'},
    const {'1': 'placeAddress', '3': 13, '4': 1, '5': 9, '10': 'placeAddress'},
    const {'1': 'placeAddress2', '3': 14, '4': 1, '5': 9, '10': 'placeAddress2'},
  ],
};

/// Descriptor for `CmdSignupAccount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cmdSignupAccountDescriptor = $convert.base64Decode('ChBDbWRTaWdudXBBY2NvdW50EhoKCHRpbWV6b25lGAEgASgJUgh0aW1lem9uZRImCg50aW1lem9uZU9mZnNldBgCIAEoBVIOdGltZXpvbmVPZmZzZXQSJAoNdmVyaWZpZWRUb2tlbhgDIAEoCVINdmVyaWZpZWRUb2tlbhIUCgVlbWFpbBgEIAEoCVIFZW1haWwSHAoJZmlyc3ROYW1lGAUgASgJUglmaXJzdE5hbWUSGgoIbGFzdE5hbWUYBiABKAlSCGxhc3ROYW1lEhwKCXN0b3JlTmFtZRgHIAEoCVIJc3RvcmVOYW1lEhwKCXN1YkRvbWFpbhgIIAEoCVIJc3ViRG9tYWluEhoKCHBsYWNlTGF0GAkgASgBUghwbGFjZUxhdBIaCghwbGFjZUxuZxgKIAEoAVIIcGxhY2VMbmcSHAoJcGxhY2VUYWdzGAsgAygJUglwbGFjZVRhZ3MSIgoMcGxhY2VDb3VudHJ5GAwgASgJUgxwbGFjZUNvdW50cnkSIgoMcGxhY2VBZGRyZXNzGA0gASgJUgxwbGFjZUFkZHJlc3MSJAoNcGxhY2VBZGRyZXNzMhgOIAEoCVINcGxhY2VBZGRyZXNzMg==');
