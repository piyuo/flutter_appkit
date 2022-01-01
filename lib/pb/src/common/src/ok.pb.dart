///
//  Generated code. Do not modify.
//  source: ok.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class OK extends pb.Object {
  $core.int mapIdXXX() => 6;
  namespace() => 'common';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OK', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  OK._() : super();
  factory OK() => create();
  factory OK.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OK.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OK clone() => OK()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OK copyWith(void Function(OK) updates) => super.copyWith((message) => updates(message as OK)) as OK; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OK create() => OK._();
  OK createEmptyInstance() => create();
  static $pb.PbList<OK> createRepeated() => $pb.PbList<OK>();
  @$core.pragma('dart2js:noInline')
  static OK getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OK>(create);
  static OK? _defaultInstance;
}

