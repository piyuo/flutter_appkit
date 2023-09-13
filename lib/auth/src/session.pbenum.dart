//
//  Generated code. Do not modify.
//  source: session.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Session_AccountStatus extends $pb.ProtobufEnum {
  static const Session_AccountStatus AccountNormal = Session_AccountStatus._(0, _omitEnumNames ? '' : 'AccountNormal');
  static const Session_AccountStatus AccountSuspendSoon = Session_AccountStatus._(1, _omitEnumNames ? '' : 'AccountSuspendSoon');
  static const Session_AccountStatus AccountSuspend = Session_AccountStatus._(2, _omitEnumNames ? '' : 'AccountSuspend');

  static const $core.List<Session_AccountStatus> values = <Session_AccountStatus> [
    AccountNormal,
    AccountSuspendSoon,
    AccountSuspend,
  ];

  static final $core.Map<$core.int, Session_AccountStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Session_AccountStatus? valueOf($core.int value) => _byValue[value];

  const Session_AccountStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
