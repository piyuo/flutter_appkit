///
//  Generated code. Do not modify.
//  source: echo_action.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command/command.dart' as command;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

class EchoRequest extends command.ProtoObject {
  $core.int mapIdXXX() {
    return 9001;
  }

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('EchoAction', createEmptyInstance: create)
        ..aOS(1, 'text')
        ..a<Int64>(2, 'like64', $pb.PbFieldType.OU6, defaultOrMaker: Int64.ZERO)
        ..hasRequiredFields = false;

  EchoRequest._() : super();
  factory EchoRequest() => create();
  factory EchoRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EchoRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EchoRequest clone() => EchoRequest()..mergeFromMessage(this);
  EchoRequest copyWith(void Function(EchoRequest) updates) =>
      super.copyWith((message) => updates(message as EchoRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EchoRequest create() => EchoRequest._();
  EchoRequest createEmptyInstance() => create();
  static $pb.PbList<EchoRequest> createRepeated() => $pb.PbList<EchoRequest>();
  static EchoRequest getDefault() => _defaultInstance ??= create()..freeze();
  static EchoRequest _defaultInstance;

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
