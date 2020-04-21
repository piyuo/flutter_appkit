///
//  Generated code. Do not modify.
//  source: num.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command.dart';

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Num extends ProtoObject {
  $core.int mapIdXXX() {
    return 2;
  }
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Num', createEmptyInstance: create)
    ..aInt64(1, 'value')
    ..hasRequiredFields = false
  ;

  Num._() : super();
  factory Num() => create();
  factory Num.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Num.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Num clone() => Num()..mergeFromMessage(this);
  Num copyWith(void Function(Num) updates) => super.copyWith((message) => updates(message as Num));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Num create() => Num._();
  Num createEmptyInstance() => create();
  static $pb.PbList<Num> createRepeated() => $pb.PbList<Num>();
  @$core.pragma('dart2js:noInline')
  static Num getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Num>(create);
  static Num _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

