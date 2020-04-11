///
//  Generated code. Do not modify.
//  source: err.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/src/command/command.dart' as command;

import 'package:protobuf/protobuf.dart' as $pb;

class Err extends command.ProtoObject {
  $core.int mapIdXXX() {
    return 1;
  }

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('Err', createEmptyInstance: create)
        ..a<$core.int>(1, 'code', $pb.PbFieldType.O3)
        ..aOS(2, 'msg')
        ..hasRequiredFields = false;

  Err._() : super();
  factory Err() => create();
  factory Err.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Err.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Err clone() => Err()..mergeFromMessage(this);
  Err copyWith(void Function(Err) updates) =>
      super.copyWith((message) => updates(message as Err));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Err create() => Err._();
  Err createEmptyInstance() => create();
  static $pb.PbList<Err> createRepeated() => $pb.PbList<Err>();
  @$core.pragma('dart2js:noInline')
  static Err getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Err>(create);
  static Err _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);
}
