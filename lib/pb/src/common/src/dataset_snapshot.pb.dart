///
//  Generated code. Do not modify.
//  source: dataset_snapshot.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class DatasetSnapshot extends pb.Object {
  $core.int mapIdXXX() => 8;
  namespace() => 'common';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DatasetSnapshot', createEmptyInstance: create)
    ..pPS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'noRefresh', protoName: 'noRefresh')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'noMore', protoName: 'noMore')
    ..hasRequiredFields = false
  ;

  DatasetSnapshot._() : super();
  factory DatasetSnapshot({
    $core.Iterable<$core.String>? value,
    $core.bool? noRefresh,
    $core.bool? noMore,
  }) {
    final _result = create();
    if (value != null) {
      _result.value.addAll(value);
    }
    if (noRefresh != null) {
      _result.noRefresh = noRefresh;
    }
    if (noMore != null) {
      _result.noMore = noMore;
    }
    return _result;
  }
  factory DatasetSnapshot.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DatasetSnapshot.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DatasetSnapshot clone() => DatasetSnapshot()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DatasetSnapshot copyWith(void Function(DatasetSnapshot) updates) => super.copyWith((message) => updates(message as DatasetSnapshot)) as DatasetSnapshot; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DatasetSnapshot create() => DatasetSnapshot._();
  DatasetSnapshot createEmptyInstance() => create();
  static $pb.PbList<DatasetSnapshot> createRepeated() => $pb.PbList<DatasetSnapshot>();
  @$core.pragma('dart2js:noInline')
  static DatasetSnapshot getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DatasetSnapshot>(create);
  static DatasetSnapshot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get value => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get noRefresh => $_getBF(1);
  @$pb.TagNumber(2)
  set noRefresh($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNoRefresh() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoRefresh() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get noMore => $_getBF(2);
  @$pb.TagNumber(3)
  set noMore($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNoMore() => $_has(2);
  @$pb.TagNumber(3)
  void clearNoMore() => clearField(3);
}

