///
//  Generated code. Do not modify.
//  source: geo-location.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use geoLocationDescriptor instead')
const GeoLocation$json = const {
  '1': 'GeoLocation',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'lat', '3': 2, '4': 1, '5': 1, '10': 'lat'},
    const {'1': 'lng', '3': 3, '4': 1, '5': 1, '10': 'lng'},
    const {'1': 'tags', '3': 4, '4': 3, '5': 9, '10': 'tags'},
    const {'1': 'country', '3': 5, '4': 1, '5': 9, '10': 'country'},
  ],
};

/// Descriptor for `GeoLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoLocationDescriptor = $convert.base64Decode('CgtHZW9Mb2NhdGlvbhIYCgdhZGRyZXNzGAEgASgJUgdhZGRyZXNzEhAKA2xhdBgCIAEoAVIDbGF0EhAKA2xuZxgDIAEoAVIDbG5nEhIKBHRhZ3MYBCADKAlSBHRhZ3MSGAoHY291bnRyeRgFIAEoCVIHY291bnRyeQ==');
