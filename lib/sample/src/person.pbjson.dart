//
//  Generated code. Do not modify.
//  source: person.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use personDescriptor instead')
const Person$json = {
  '1': 'Person',
  '2': [
    {'1': 'm', '3': 1, '4': 1, '5': 11, '6': '.Model', '10': 'm'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'age', '3': 3, '4': 1, '5': 5, '10': 'age'},
    {'1': 'enumValue', '3': 4, '4': 1, '5': 14, '6': '.Person.PersonGender', '10': 'enumValue'},
    {'1': 'timestampValue', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestampValue'},
    {'1': 'mapValue', '3': 6, '4': 3, '5': 11, '6': '.Person.MapValueEntry', '10': 'mapValue'},
    {'1': 'stringValue', '3': 7, '4': 1, '5': 9, '10': 'stringValue'},
    {'1': 'int32Value', '3': 8, '4': 1, '5': 5, '10': 'int32Value'},
    {'1': 'floatValue', '3': 9, '4': 1, '5': 2, '10': 'floatValue'},
    {'1': 'doubleValue', '3': 10, '4': 1, '5': 1, '10': 'doubleValue'},
    {'1': 'boolValue', '3': 11, '4': 1, '5': 8, '10': 'boolValue'},
    {'1': 'stringListValue', '3': 12, '4': 3, '5': 9, '10': 'stringListValue'},
    {'1': 'int32ListValue', '3': 13, '4': 3, '5': 5, '10': 'int32ListValue'},
    {'1': 'floatListValue', '3': 14, '4': 3, '5': 2, '10': 'floatListValue'},
    {'1': 'doubleListValue', '3': 15, '4': 3, '5': 1, '10': 'doubleListValue'},
    {'1': 'boolListValue', '3': 16, '4': 3, '5': 8, '10': 'boolListValue'},
    {'1': 'timestampListValue', '3': 17, '4': 3, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestampListValue'},
  ],
  '3': [Person_MapValueEntry$json],
  '4': [Person_PersonGender$json],
};

@$core.Deprecated('Use personDescriptor instead')
const Person_MapValueEntry$json = {
  '1': 'MapValueEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use personDescriptor instead')
const Person_PersonGender$json = {
  '1': 'PersonGender',
  '2': [
    {'1': 'PersonMale', '2': 0},
    {'1': 'PersonFemale', '2': 1},
  ],
};

/// Descriptor for `Person`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personDescriptor = $convert.base64Decode(
    'CgZQZXJzb24SFAoBbRgBIAEoCzIGLk1vZGVsUgFtEhIKBG5hbWUYAiABKAlSBG5hbWUSEAoDYW'
    'dlGAMgASgFUgNhZ2USMgoJZW51bVZhbHVlGAQgASgOMhQuUGVyc29uLlBlcnNvbkdlbmRlclIJ'
    'ZW51bVZhbHVlEkIKDnRpbWVzdGFtcFZhbHVlGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIOdGltZXN0YW1wVmFsdWUSMQoIbWFwVmFsdWUYBiADKAsyFS5QZXJzb24uTWFwVmFs'
    'dWVFbnRyeVIIbWFwVmFsdWUSIAoLc3RyaW5nVmFsdWUYByABKAlSC3N0cmluZ1ZhbHVlEh4KCm'
    'ludDMyVmFsdWUYCCABKAVSCmludDMyVmFsdWUSHgoKZmxvYXRWYWx1ZRgJIAEoAlIKZmxvYXRW'
    'YWx1ZRIgCgtkb3VibGVWYWx1ZRgKIAEoAVILZG91YmxlVmFsdWUSHAoJYm9vbFZhbHVlGAsgAS'
    'gIUglib29sVmFsdWUSKAoPc3RyaW5nTGlzdFZhbHVlGAwgAygJUg9zdHJpbmdMaXN0VmFsdWUS'
    'JgoOaW50MzJMaXN0VmFsdWUYDSADKAVSDmludDMyTGlzdFZhbHVlEiYKDmZsb2F0TGlzdFZhbH'
    'VlGA4gAygCUg5mbG9hdExpc3RWYWx1ZRIoCg9kb3VibGVMaXN0VmFsdWUYDyADKAFSD2RvdWJs'
    'ZUxpc3RWYWx1ZRIkCg1ib29sTGlzdFZhbHVlGBAgAygIUg1ib29sTGlzdFZhbHVlEkoKEnRpbW'
    'VzdGFtcExpc3RWYWx1ZRgRIAMoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEnRpbWVz'
    'dGFtcExpc3RWYWx1ZRo7Cg1NYXBWYWx1ZUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbH'
    'VlGAIgASgFUgV2YWx1ZToCOAEiMAoMUGVyc29uR2VuZGVyEg4KClBlcnNvbk1hbGUQABIQCgxQ'
    'ZXJzb25GZW1hbGUQAQ==');

