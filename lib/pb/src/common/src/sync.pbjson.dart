///
//  Generated code. Do not modify.
//  source: sync.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use syncDescriptor instead')
const Sync$json = const {
  '1': 'Sync',
  '2': const [
    const {'1': 'act', '3': 1, '4': 1, '5': 14, '6': '.Sync.ACT', '10': 'act'},
    const {'1': 'time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'time'},
    const {'1': 'rows', '3': 3, '4': 1, '5': 5, '10': 'rows'},
    const {'1': 'page', '3': 4, '4': 1, '5': 5, '10': 'page'},
  ],
  '4': const [Sync_ACT$json],
};

@$core.Deprecated('Use syncDescriptor instead')
const Sync_ACT$json = const {
  '1': 'ACT',
  '2': const [
    const {'1': 'ACT_UNSPECIFIED', '2': 0},
    const {'1': 'ACT_INIT', '2': 1},
    const {'1': 'ACT_REFRESH', '2': 2},
    const {'1': 'ACT_FETCH', '2': 3},
  ],
};

/// Descriptor for `Sync`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncDescriptor = $convert.base64Decode('CgRTeW5jEhsKA2FjdBgBIAEoDjIJLlN5bmMuQUNUUgNhY3QSLgoEdGltZRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBHRpbWUSEgoEcm93cxgDIAEoBVIEcm93cxISCgRwYWdlGAQgASgFUgRwYWdlIkgKA0FDVBITCg9BQ1RfVU5TUEVDSUZJRUQQABIMCghBQ1RfSU5JVBABEg8KC0FDVF9SRUZSRVNIEAISDQoJQUNUX0ZFVENIEAM=');
