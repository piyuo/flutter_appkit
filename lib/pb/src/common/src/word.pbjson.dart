///
//  Generated code. Do not modify.
//  source: word.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use wordDescriptor instead')
const Word$json = const {
  '1': 'Word',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.Word.WordType', '10': 'type'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '4': const [Word_WordType$json],
};

@$core.Deprecated('Use wordDescriptor instead')
const Word_WordType$json = const {
  '1': 'WordType',
  '2': const [
    const {'1': 'WORD_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'WORD_TYPE_TEXT', '2': 1},
    const {'1': 'WORD_TYPE_IMAGE', '2': 2},
    const {'1': 'WORD_TYPE_VIDEO', '2': 3},
    const {'1': 'WORD_TYPE_AUDIO', '2': 4},
    const {'1': 'WORD_TYPE_FILE', '2': 5},
    const {'1': 'WORD_TYPE_EMOJI', '2': 6},
  ],
};

/// Descriptor for `Word`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wordDescriptor = $convert.base64Decode('CgRXb3JkEiIKBHR5cGUYASABKA4yDi5Xb3JkLldvcmRUeXBlUgR0eXBlEhQKBXZhbHVlGAIgASgJUgV2YWx1ZSKhAQoIV29yZFR5cGUSGQoVV09SRF9UWVBFX1VOU1BFQ0lGSUVEEAASEgoOV09SRF9UWVBFX1RFWFQQARITCg9XT1JEX1RZUEVfSU1BR0UQAhITCg9XT1JEX1RZUEVfVklERU8QAxITCg9XT1JEX1RZUEVfQVVESU8QBBISCg5XT1JEX1RZUEVfRklMRRAFEhMKD1dPUkRfVFlQRV9FTU9KSRAG');
