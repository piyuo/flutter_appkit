///
//  Generated code. Do not modify.
//  source: person.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use personDescriptor instead')
const Person$json = const {
  '1': 'Person',
  '2': const [
    const {'1': 'm', '3': 1, '4': 1, '5': 11, '6': '.Model', '10': 'm'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'age', '3': 3, '4': 1, '5': 5, '10': 'age'},
    const {'1': 'enumValue', '3': 4, '4': 1, '5': 14, '6': '.Person.PersonGender', '10': 'enumValue'},
    const {'1': 'timestampValue', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestampValue'},
    const {'1': 'mapValue', '3': 6, '4': 3, '5': 11, '6': '.Person.MapValueEntry', '10': 'mapValue'},
    const {'1': 'stringValue', '3': 7, '4': 1, '5': 9, '10': 'stringValue'},
    const {'1': 'int32Value', '3': 8, '4': 1, '5': 5, '10': 'int32Value'},
    const {'1': 'floatValue', '3': 9, '4': 1, '5': 2, '10': 'floatValue'},
    const {'1': 'doubleValue', '3': 10, '4': 1, '5': 1, '10': 'doubleValue'},
    const {'1': 'boolValue', '3': 11, '4': 1, '5': 8, '10': 'boolValue'},
    const {'1': 'stringListValue', '3': 12, '4': 3, '5': 9, '10': 'stringListValue'},
    const {'1': 'int32ListValue', '3': 13, '4': 3, '5': 5, '10': 'int32ListValue'},
    const {'1': 'floatListValue', '3': 14, '4': 3, '5': 2, '10': 'floatListValue'},
    const {'1': 'doubleListValue', '3': 15, '4': 3, '5': 1, '10': 'doubleListValue'},
    const {'1': 'boolListValue', '3': 16, '4': 3, '5': 8, '10': 'boolListValue'},
  ],
  '3': const [Person_MapValueEntry$json],
  '4': const [Person_PersonGender$json],
};

@$core.Deprecated('Use personDescriptor instead')
const Person_MapValueEntry$json = const {
  '1': 'MapValueEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': const {'7': true},
};

@$core.Deprecated('Use personDescriptor instead')
const Person_PersonGender$json = const {
  '1': 'PersonGender',
  '2': const [
    const {'1': 'PersonMale', '2': 0},
    const {'1': 'PersonFemale', '2': 1},
  ],
};

/// Descriptor for `Person`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personDescriptor = $convert.base64Decode('CgZQZXJzb24SFAoBbRgBIAEoCzIGLk1vZGVsUgFtEhIKBG5hbWUYAiABKAlSBG5hbWUSEAoDYWdlGAMgASgFUgNhZ2USMgoJZW51bVZhbHVlGAQgASgOMhQuUGVyc29uLlBlcnNvbkdlbmRlclIJZW51bVZhbHVlEkIKDnRpbWVzdGFtcFZhbHVlGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOdGltZXN0YW1wVmFsdWUSMQoIbWFwVmFsdWUYBiADKAsyFS5QZXJzb24uTWFwVmFsdWVFbnRyeVIIbWFwVmFsdWUSIAoLc3RyaW5nVmFsdWUYByABKAlSC3N0cmluZ1ZhbHVlEh4KCmludDMyVmFsdWUYCCABKAVSCmludDMyVmFsdWUSHgoKZmxvYXRWYWx1ZRgJIAEoAlIKZmxvYXRWYWx1ZRIgCgtkb3VibGVWYWx1ZRgKIAEoAVILZG91YmxlVmFsdWUSHAoJYm9vbFZhbHVlGAsgASgIUglib29sVmFsdWUSKAoPc3RyaW5nTGlzdFZhbHVlGAwgAygJUg9zdHJpbmdMaXN0VmFsdWUSJgoOaW50MzJMaXN0VmFsdWUYDSADKAVSDmludDMyTGlzdFZhbHVlEiYKDmZsb2F0TGlzdFZhbHVlGA4gAygCUg5mbG9hdExpc3RWYWx1ZRIoCg9kb3VibGVMaXN0VmFsdWUYDyADKAFSD2RvdWJsZUxpc3RWYWx1ZRIkCg1ib29sTGlzdFZhbHVlGBAgAygIUg1ib29sTGlzdFZhbHVlGjsKDU1hcFZhbHVlRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4ASIwCgxQZXJzb25HZW5kZXISDgoKUGVyc29uTWFsZRAAEhAKDFBlcnNvbkZlbWFsZRAB');
