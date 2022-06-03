///
//  Generated code. Do not modify.
//  source: model.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Model_ModelState extends $pb.ProtobufEnum {
  static const Model_ModelState ModelActive = Model_ModelState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ModelActive');
  static const Model_ModelState ModelArchived = Model_ModelState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ModelArchived');
  static const Model_ModelState ModelDeleted = Model_ModelState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ModelDeleted');

  static const $core.List<Model_ModelState> values = <Model_ModelState> [
    ModelActive,
    ModelArchived,
    ModelDeleted,
  ];

  static final $core.Map<$core.int, Model_ModelState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Model_ModelState? valueOf($core.int value) => _byValue[value];

  const Model_ModelState._($core.int v, $core.String n) : super(v, n);
}

