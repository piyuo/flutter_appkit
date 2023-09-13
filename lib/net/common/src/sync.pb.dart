//
//  Generated code. Do not modify.
//  source: sync.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

// ignore: implementation_imports
import 'package:libcli/google/src/timestamp.pb.dart' as $0;

/// / Sync is a request for sync client dataset and server database
/// / handler must deal 3 cases:
/// / 1. has refresh and has fetch: it always happens when client init, need make
/// / sure result is fill with enough rows
/// / 2. has refresh and no fetch: it happens when client refresh, no need to
/// / fetch
/// / 3. no refresh and has fetch: it happens when client scroll, need to fetch
/// / but no refresh
class Sync extends net.Object {
  $core.int mapIdXXX() => 8;
  get namespace => 'common';

  factory Sync({
    $0.Timestamp? refresh,
    $0.Timestamp? fetch,
    $core.int? rows,
    $core.int? page,
  }) {
    final $result = create();
    if (refresh != null) {
      $result.refresh = refresh;
    }
    if (fetch != null) {
      $result.fetch = fetch;
    }
    if (rows != null) {
      $result.rows = rows;
    }
    if (page != null) {
      $result.page = page;
    }
    return $result;
  }
  Sync._() : super();
  factory Sync.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Sync.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Sync', createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'refresh', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'fetch', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'rows', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'page', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Sync clone() => Sync()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Sync copyWith(void Function(Sync) updates) => super.copyWith((message) => updates(message as Sync)) as Sync;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Sync create() => Sync._();
  Sync createEmptyInstance() => create();
  static $pb.PbList<Sync> createRepeated() => $pb.PbList<Sync>();
  @$core.pragma('dart2js:noInline')
  static Sync getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Sync>(create);
  static Sync? _defaultInstance;

  /// / refresh time stamp for refresh
  @$pb.TagNumber(1)
  $0.Timestamp get refresh => $_getN(0);
  @$pb.TagNumber(1)
  set refresh($0.Timestamp v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRefresh() => $_has(0);
  @$pb.TagNumber(1)
  void clearRefresh() => clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureRefresh() => $_ensure(0);

  /// / fetch time stamp for fetch
  @$pb.TagNumber(2)
  $0.Timestamp get fetch => $_getN(1);
  @$pb.TagNumber(2)
  set fetch($0.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFetch() => $_has(1);
  @$pb.TagNumber(2)
  void clearFetch() => clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureFetch() => $_ensure(1);

  /// / rows is rows per page for fetch
  @$pb.TagNumber(3)
  $core.int get rows => $_getIZ(2);
  @$pb.TagNumber(3)
  set rows($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRows() => $_has(2);
  @$pb.TagNumber(3)
  void clearRows() => clearField(3);

  /// / page is page number for fetch
  @$pb.TagNumber(4)
  $core.int get page => $_getIZ(3);
  @$pb.TagNumber(4)
  set page($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPage() => clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
