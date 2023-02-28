///
//  Generated code. Do not modify.
//  source: session.proto
//
// @dart = 2.12
// ignore_for_file: constant_identifier_names, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Session_AccountStatus extends $pb.ProtobufEnum {
  static const Session_AccountStatus AccountNormal = Session_AccountStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AccountNormal');
  static const Session_AccountStatus AccountSuspendSoon = Session_AccountStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AccountSuspendSoon');
  static const Session_AccountStatus AccountSuspend = Session_AccountStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'AccountSuspend');

  static const $core.List<Session_AccountStatus> values = <Session_AccountStatus> [
    AccountNormal,
    AccountSuspendSoon,
    AccountSuspend,
  ];

  static final $core.Map<$core.int, Session_AccountStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Session_AccountStatus? valueOf($core.int value) => _byValue[value];

  const Session_AccountStatus._($core.int v, $core.String n) : super(v, n);
}

