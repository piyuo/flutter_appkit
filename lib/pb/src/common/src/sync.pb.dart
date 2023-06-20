///
//  Generated code. Do not modify.
//  source: sync.proto
//
// @dart = 2.12
// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

// ignore: implementation_imports
import 'package:libcli/google/src/timestamp.pb.dart' as $0;

import 'sync.pbenum.dart';

export 'sync.pbenum.dart';

class Sync extends pb.Object {
  $core.int mapIdXXX() => 8;
  get namespace => 'common';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Sync', createEmptyInstance: create)
    ..e<Sync_ACT>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'act', $pb.PbFieldType.OE, defaultOrMaker: Sync_ACT.ACT_UNSPECIFIED, valueOf: Sync_ACT.valueOf, enumValues: Sync_ACT.values)
    ..aOM<$0.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rows', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'page', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  Sync._() : super();
  factory Sync({
    Sync_ACT? act,
    $0.Timestamp? time,
    $core.int? rows,
    $core.int? page,
  }) {
    final _result = create();
    if (act != null) {
      _result.act = act;
    }
    if (time != null) {
      _result.time = time;
    }
    if (rows != null) {
      _result.rows = rows;
    }
    if (page != null) {
      _result.page = page;
    }
    return _result;
  }
  factory Sync.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Sync.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Sync clone() => Sync()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Sync copyWith(void Function(Sync) updates) => super.copyWith((message) => updates(message as Sync)) as Sync; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Sync create() => Sync._();
  Sync createEmptyInstance() => create();
  static $pb.PbList<Sync> createRepeated() => $pb.PbList<Sync>();
  @$core.pragma('dart2js:noInline')
  static Sync getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sync>(create);
  static Sync? _defaultInstance;

  @$pb.TagNumber(1)
  Sync_ACT get act => $_getN(0);
  @$pb.TagNumber(1)
  set act(Sync_ACT v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAct() => $_has(0);
  @$pb.TagNumber(1)
  void clearAct() => clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get time => $_getN(1);
  @$pb.TagNumber(2)
  set time($0.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get rows => $_getIZ(2);
  @$pb.TagNumber(3)
  set rows($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRows() => $_has(2);
  @$pb.TagNumber(3)
  void clearRows() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get page => $_getIZ(3);
  @$pb.TagNumber(4)
  set page($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPage() => clearField(4);
}

