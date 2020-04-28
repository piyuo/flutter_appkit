///
//  Generated code. Do not modify.
//  source: err.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command.dart';

import 'package:protobuf/protobuf.dart' as $pb;

class Err extends ProtoObject {
  $core.int mapIdXXX() {
    return 0;
  }
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Err', createEmptyInstance: create)
    ..aOS(1, 'code')
    ..hasRequiredFields = false
  ;

  Err._() : super();
  factory Err() => create();
  factory Err.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Err.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Err clone() => Err()..mergeFromMessage(this);
  Err copyWith(void Function(Err) updates) => super.copyWith((message) => updates(message as Err));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Err create() => Err._();
  Err createEmptyInstance() => create();
  static $pb.PbList<Err> createRepeated() => $pb.PbList<Err>();
  @$core.pragma('dart2js:noInline')
  static Err getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Err>(create);
  static Err _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);
}

