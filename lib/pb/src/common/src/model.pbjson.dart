///
//  Generated code. Do not modify.
//  source: model.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use modelDescriptor instead')
const Model$json = const {
  '1': 'Model',
  '2': const [
    const {'1': 'i', '3': 1, '4': 1, '5': 9, '10': 'i'},
    const {'1': 't', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 't'},
    const {'1': 's', '3': 3, '4': 1, '5': 14, '6': '.Model.ModelState', '10': 's'},
  ],
  '4': const [Model_ModelState$json],
};

@$core.Deprecated('Use modelDescriptor instead')
const Model_ModelState$json = const {
  '1': 'ModelState',
  '2': const [
    const {'1': 'ModelJustCreated', '2': 0},
    const {'1': 'ModelActive', '2': 1},
    const {'1': 'ModelDraft', '2': 2},
    const {'1': 'ModelArchived', '2': 3},
    const {'1': 'ModelDeleted', '2': 4},
  ],
};

/// Descriptor for `Model`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelDescriptor = $convert.base64Decode('CgVNb2RlbBIMCgFpGAEgASgJUgFpEigKAXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgF0Eh8KAXMYAyABKA4yES5Nb2RlbC5Nb2RlbFN0YXRlUgFzImgKCk1vZGVsU3RhdGUSFAoQTW9kZWxKdXN0Q3JlYXRlZBAAEg8KC01vZGVsQWN0aXZlEAESDgoKTW9kZWxEcmFmdBACEhEKDU1vZGVsQXJjaGl2ZWQQAxIQCgxNb2RlbERlbGV0ZWQQBA==');
