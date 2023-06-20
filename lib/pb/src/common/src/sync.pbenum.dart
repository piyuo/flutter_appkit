///
//  Generated code. Do not modify.
//  source: sync.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Sync_ACT extends $pb.ProtobufEnum {
  static const Sync_ACT ACT_UNSPECIFIED = Sync_ACT._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACT_UNSPECIFIED');
  static const Sync_ACT ACT_INIT = Sync_ACT._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACT_INIT');
  static const Sync_ACT ACT_REFRESH = Sync_ACT._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACT_REFRESH');
  static const Sync_ACT ACT_FETCH = Sync_ACT._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'ACT_FETCH');

  static const $core.List<Sync_ACT> values = <Sync_ACT> [
    ACT_UNSPECIFIED,
    ACT_INIT,
    ACT_REFRESH,
    ACT_FETCH,
  ];

  static final $core.Map<$core.int, Sync_ACT> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Sync_ACT? valueOf($core.int value) => _byValue[value];

  const Sync_ACT._($core.int v, $core.String n) : super(v, n);
}

