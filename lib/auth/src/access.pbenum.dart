//
//  Generated code. Do not modify.
//  source: access.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// State is state of this access
class Access_State extends $pb.ProtobufEnum {
  static const Access_State STATE_UNSPECIFIED = Access_State._(0, _omitEnumNames ? '' : 'STATE_UNSPECIFIED');
  static const Access_State STATE_OK = Access_State._(1, _omitEnumNames ? '' : 'STATE_OK');
  static const Access_State STATE_SUSPEND = Access_State._(2, _omitEnumNames ? '' : 'STATE_SUSPEND');
  static const Access_State STATE_BAND = Access_State._(3, _omitEnumNames ? '' : 'STATE_BAND');

  static const $core.List<Access_State> values = <Access_State> [
    STATE_UNSPECIFIED,
    STATE_OK,
    STATE_SUSPEND,
    STATE_BAND,
  ];

  static final $core.Map<$core.int, Access_State> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Access_State? valueOf($core.int value) => _byValue[value];

  const Access_State._($core.int v, $core.String n) : super(v, n);
}

/// Region is region of user
class Access_Region extends $pb.ProtobufEnum {
  static const Access_Region REGION_UNSPECIFIED = Access_Region._(0, _omitEnumNames ? '' : 'REGION_UNSPECIFIED');
  static const Access_Region REGION_TW = Access_Region._(1, _omitEnumNames ? '' : 'REGION_TW');

  static const $core.List<Access_Region> values = <Access_Region> [
    REGION_UNSPECIFIED,
    REGION_TW,
  ];

  static final $core.Map<$core.int, Access_Region> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Access_Region? valueOf($core.int value) => _byValue[value];

  const Access_Region._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
