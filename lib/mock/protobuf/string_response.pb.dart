///
//  Generated code. Do not modify.
//  source: string_response.proto
//
// @dart = 2.12
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command.dart' as command;
import 'package:libpb/pb.dart';

import 'package:protobuf/protobuf.dart' as $pb;

class StringResponse extends ProtoObject {
  $core.int mapIdXXX() {
    return 1002;
  }

  static final $pb.BuilderInfo _i = $pb.BuilderInfo('StringResponse', createEmptyInstance: create)
    ..aOS(1, 'text')
    ..hasRequiredFields = false;

  StringResponse._() : super();
  factory StringResponse() => create();
  factory StringResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory StringResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  StringResponse clone() => StringResponse()..mergeFromMessage(this);
  StringResponse copyWith(void Function(StringResponse) updates) =>
      super.copyWith((message) => updates(message as StringResponse)) as StringResponse;

  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static StringResponse create() => StringResponse._();
  StringResponse createEmptyInstance() => create();
  static $pb.PbList<StringResponse> createRepeated() => $pb.PbList<StringResponse>();
  static StringResponse getDefault() => _defaultInstance ??= create()..freeze();
  static StringResponse? _defaultInstance;

  $core.String get text => $_getS(0, '');
  set text($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasText() => $_has(0);
  void clearText() => clearField(1);
}
