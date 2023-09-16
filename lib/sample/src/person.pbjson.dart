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
    {'1': 'enum_value', '3': 4, '4': 1, '5': 14, '6': '.Person.Gender', '10': 'enumValue'},
    {'1': 'timestamp_value', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestampValue'},
    {'1': 'map_value', '3': 6, '4': 3, '5': 11, '6': '.Person.MapValueEntry', '10': 'mapValue'},
    {'1': 'string_value', '3': 7, '4': 1, '5': 9, '10': 'stringValue'},
    {'1': 'int32_value', '3': 8, '4': 1, '5': 5, '10': 'int32Value'},
    {'1': 'float_value', '3': 9, '4': 1, '5': 2, '10': 'floatValue'},
    {'1': 'double_value', '3': 10, '4': 1, '5': 1, '10': 'doubleValue'},
    {'1': 'bool_value', '3': 11, '4': 1, '5': 8, '10': 'boolValue'},
    {'1': 'string_list_values', '3': 12, '4': 3, '5': 9, '10': 'stringListValues'},
    {'1': 'int32_list_values', '3': 13, '4': 3, '5': 5, '10': 'int32ListValues'},
    {'1': 'float_list_values', '3': 14, '4': 3, '5': 2, '10': 'floatListValues'},
    {'1': 'double_list_values', '3': 15, '4': 3, '5': 1, '10': 'doubleListValues'},
    {'1': 'bool_list_values', '3': 16, '4': 3, '5': 8, '10': 'boolListValues'},
    {'1': 'timestamp_list_values', '3': 17, '4': 3, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestampListValues'},
  ],
  '3': [Person_MapValueEntry$json],
  '4': [Person_Gender$json],
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
const Person_Gender$json = {
  '1': 'Gender',
  '2': [
    {'1': 'GENDER_UNSPECIFIED', '2': 0},
    {'1': 'GENDER_MALE', '2': 1},
    {'1': 'GENDER_FEMALE', '2': 2},
  ],
};

/// Descriptor for `Person`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List personDescriptor = $convert.base64Decode(
    'CgZQZXJzb24SFAoBbRgBIAEoCzIGLk1vZGVsUgFtEhIKBG5hbWUYAiABKAlSBG5hbWUSEAoDYW'
    'dlGAMgASgFUgNhZ2USLQoKZW51bV92YWx1ZRgEIAEoDjIOLlBlcnNvbi5HZW5kZXJSCWVudW1W'
    'YWx1ZRJDCg90aW1lc3RhbXBfdmFsdWUYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUg50aW1lc3RhbXBWYWx1ZRIyCgltYXBfdmFsdWUYBiADKAsyFS5QZXJzb24uTWFwVmFsdWVF'
    'bnRyeVIIbWFwVmFsdWUSIQoMc3RyaW5nX3ZhbHVlGAcgASgJUgtzdHJpbmdWYWx1ZRIfCgtpbn'
    'QzMl92YWx1ZRgIIAEoBVIKaW50MzJWYWx1ZRIfCgtmbG9hdF92YWx1ZRgJIAEoAlIKZmxvYXRW'
    'YWx1ZRIhCgxkb3VibGVfdmFsdWUYCiABKAFSC2RvdWJsZVZhbHVlEh0KCmJvb2xfdmFsdWUYCy'
    'ABKAhSCWJvb2xWYWx1ZRIsChJzdHJpbmdfbGlzdF92YWx1ZXMYDCADKAlSEHN0cmluZ0xpc3RW'
    'YWx1ZXMSKgoRaW50MzJfbGlzdF92YWx1ZXMYDSADKAVSD2ludDMyTGlzdFZhbHVlcxIqChFmbG'
    '9hdF9saXN0X3ZhbHVlcxgOIAMoAlIPZmxvYXRMaXN0VmFsdWVzEiwKEmRvdWJsZV9saXN0X3Zh'
    'bHVlcxgPIAMoAVIQZG91YmxlTGlzdFZhbHVlcxIoChBib29sX2xpc3RfdmFsdWVzGBAgAygIUg'
    '5ib29sTGlzdFZhbHVlcxJOChV0aW1lc3RhbXBfbGlzdF92YWx1ZXMYESADKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUhN0aW1lc3RhbXBMaXN0VmFsdWVzGjsKDU1hcFZhbHVlRW50cn'
    'kSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4ASJECgZHZW5kZXIS'
    'FgoSR0VOREVSX1VOU1BFQ0lGSUVEEAASDwoLR0VOREVSX01BTEUQARIRCg1HRU5ERVJfRkVNQU'
    'xFEAI=');

