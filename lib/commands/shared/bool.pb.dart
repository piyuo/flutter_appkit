///
//  Generated code. Do not modify.
//  source: bool.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command.dart';

import 'package:protobuf/protobuf.dart' as $pb;

class Bool extends ProtoObject {
  $core.int mapIdXXX() {
    return 1;
  }
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Bool', createEmptyInstance: create)
    ..aOB(1, 'value')
    ..hasRequiredFields = false
  ;

  Bool._() : super();
  factory Bool() => create();
  factory Bool.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Bool.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Bool clone() => Bool()..mergeFromMessage(this);
  Bool copyWith(void Function(Bool) updates) => super.copyWith((message) => updates(message as Bool));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Bool create() => Bool._();
  Bool createEmptyInstance() => create();
  static $pb.PbList<Bool> createRepeated() => $pb.PbList<Bool>();
  @$core.pragma('dart2js:noInline')
  static Bool getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bool>(create);
  static Bool _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get value => $_getBF(0);
  @$pb.TagNumber(1)
  set value($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

