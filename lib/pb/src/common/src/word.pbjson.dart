//
//  Generated code. Do not modify.
//  source: word.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use wordDescriptor instead')
const Word$json = {
  '1': 'Word',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.Word.WordType', '10': 'type'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'ratio', '3': 3, '4': 1, '5': 1, '10': 'ratio'},
  ],
  '4': [Word_WordType$json],
};

@$core.Deprecated('Use wordDescriptor instead')
const Word_WordType$json = {
  '1': 'WordType',
  '2': [
    {'1': 'WORD_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'WORD_TYPE_TEXT', '2': 1},
    {'1': 'WORD_TYPE_IMAGE', '2': 2},
    {'1': 'WORD_TYPE_VIDEO', '2': 3},
    {'1': 'WORD_TYPE_AUDIO', '2': 4},
    {'1': 'WORD_TYPE_FILE', '2': 5},
    {'1': 'WORD_TYPE_EMOJI', '2': 6},
  ],
};

/// Descriptor for `Word`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wordDescriptor = $convert.base64Decode(
    'CgRXb3JkEiIKBHR5cGUYASABKA4yDi5Xb3JkLldvcmRUeXBlUgR0eXBlEhQKBXZhbHVlGAIgAS'
    'gJUgV2YWx1ZRIUCgVyYXRpbxgDIAEoAVIFcmF0aW8ioQEKCFdvcmRUeXBlEhkKFVdPUkRfVFlQ'
    'RV9VTlNQRUNJRklFRBAAEhIKDldPUkRfVFlQRV9URVhUEAESEwoPV09SRF9UWVBFX0lNQUdFEA'
    'ISEwoPV09SRF9UWVBFX1ZJREVPEAMSEwoPV09SRF9UWVBFX0FVRElPEAQSEgoOV09SRF9UWVBF'
    'X0ZJTEUQBRITCg9XT1JEX1RZUEVfRU1PSkkQBg==');

