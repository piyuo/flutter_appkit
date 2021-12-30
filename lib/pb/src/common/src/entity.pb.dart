///
//  Generated code. Do not modify.
//  source: entity.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

// ignore: implementation_imports
import 'package:libcli/pb/src/google/src/timestamp.pb.dart' as $0;

class Entity extends pb.Object {
  $core.int mapIdXXX() => 2;

  $core.int compareTo(pb.Object other) => other is Entity ? other.id.compareTo(this.id) : -1;

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Entity', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOM<$0.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updateTime', protoName: 'updateTime', subBuilder: $0.Timestamp.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'notGoingToChange', protoName: 'notGoingToChange')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deleted')
    ..hasRequiredFields = false
  ;

  Entity._() : super();
  factory Entity({
    $core.String? id,
    $0.Timestamp? updateTime,
    $core.bool? notGoingToChange,
    $core.bool? deleted,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (updateTime != null) {
      _result.updateTime = updateTime;
    }
    if (notGoingToChange != null) {
      _result.notGoingToChange = notGoingToChange;
    }
    if (deleted != null) {
      _result.deleted = deleted;
    }
    return _result;
  }
  factory Entity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Entity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Entity clone() => Entity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Entity copyWith(void Function(Entity) updates) => super.copyWith((message) => updates(message as Entity)) as Entity; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Entity create() => Entity._();
  Entity createEmptyInstance() => create();
  static $pb.PbList<Entity> createRepeated() => $pb.PbList<Entity>();
  @$core.pragma('dart2js:noInline')
  static Entity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Entity>(create);
  static Entity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get updateTime => $_getN(1);
  @$pb.TagNumber(2)
  set updateTime($0.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdateTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdateTime() => clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureUpdateTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get notGoingToChange => $_getBF(2);
  @$pb.TagNumber(3)
  set notGoingToChange($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotGoingToChange() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotGoingToChange() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get deleted => $_getBF(3);
  @$pb.TagNumber(4)
  set deleted($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDeleted() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeleted() => clearField(4);
}

