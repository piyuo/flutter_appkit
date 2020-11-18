///
//  Generated code. Do not modify.
//  source: echo_action.proto
//
// @dart = 2.12
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command.dart' as command;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:libpb/pb.dart';

class EchoAction extends ProtoObject {
  $core.int mapIdXXX() {
    return 9001;
  }

  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EchoAction', createEmptyInstance: create)
    ..aOS(1, 'text')
    ..a<Int64>(2, 'like64', $pb.PbFieldType.OU6, defaultOrMaker: Int64.ZERO)
    ..hasRequiredFields = false;

  EchoAction._() : super();
  factory EchoAction() => create();
  factory EchoAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EchoAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EchoAction clone() => EchoAction()..mergeFromMessage(this);
  EchoAction copyWith(void Function(EchoAction) updates) =>
      super.copyWith((message) => updates(message as EchoAction)) as EchoAction;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EchoAction create() => EchoAction._();
  EchoAction createEmptyInstance() => create();
  static $pb.PbList<EchoAction> createRepeated() => $pb.PbList<EchoAction>();
  static EchoAction getDefault() => _defaultInstance ??= create()..freeze();
  static EchoAction? _defaultInstance;

  $core.String get text => $_getS(0, '');
  set text($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasText() => $_has(0);
  void clearText() => clearField(1);

  Int64 get like64 => $_getI64(1);
  set like64(Int64 v) {
    $_setInt64(1, v);
  }

  $core.bool hasLike64() => $_has(1);
  void clearLike64() => clearField(2);
}
