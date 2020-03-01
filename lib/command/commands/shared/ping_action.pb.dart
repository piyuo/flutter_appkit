///
//  Generated code. Do not modify.
//  source: ping_action.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command/command.dart' as command;

import 'package:protobuf/protobuf.dart' as $pb;

class PingAction extends command.ProtoObject {
  $core.int mapIdXXX() {
    return 4;
  }
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PingAction', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  PingAction._() : super();
  factory PingAction() => create();
  factory PingAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PingAction clone() => PingAction()..mergeFromMessage(this);
  PingAction copyWith(void Function(PingAction) updates) => super.copyWith((message) => updates(message as PingAction));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PingAction create() => PingAction._();
  PingAction createEmptyInstance() => create();
  static $pb.PbList<PingAction> createRepeated() => $pb.PbList<PingAction>();
  @$core.pragma('dart2js:noInline')
  static PingAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingAction>(create);
  static PingAction _defaultInstance;
}

