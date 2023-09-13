//
//  Generated code. Do not modify.
//  source: geo-location.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use geoLocationDescriptor instead')
const GeoLocation$json = {
  '1': 'GeoLocation',
  '2': [
    {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    {'1': 'lat', '3': 2, '4': 1, '5': 1, '10': 'lat'},
    {'1': 'lng', '3': 3, '4': 1, '5': 1, '10': 'lng'},
    {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'country', '3': 5, '4': 1, '5': 9, '10': 'country'},
  ],
};

/// Descriptor for `GeoLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoLocationDescriptor = $convert.base64Decode(
    'CgtHZW9Mb2NhdGlvbhIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEhAKA2xhdBgCIAEoAVIDbG'
    'F0EhAKA2xuZxgDIAEoAVIDbG5nEhIKBHRhZ3MYBCADKAlSBHRhZ3MSGAoHY291bnRyeRgFIAEo'
    'CVIHY291bnRyeQ==');

