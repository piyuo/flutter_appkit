//
//  Generated code. Do not modify.
//  source: model.proto
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

/// Model contain data model identify information
class Model extends net.Object {
  $core.int mapIdXXX() => 3;
  get namespace => 'common';

  factory Model({
    $core.String? i,
    $0.Timestamp? t,
    $core.bool? d,
  }) {
    final $result = create();
    if (i != null) {
      $result.i = i;
    }
    if (t != null) {
      $result.t = t;
    }
    if (d != null) {
      $result.d = d;
    }
    return $result;
  }
  Model._() : super();
  factory Model.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Model.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Model', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'i')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 't', subBuilder: $0.Timestamp.create)
    ..aOB(3, _omitFieldNames ? '' : 'd')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Model clone() => Model()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Model copyWith(void Function(Model) updates) => super.copyWith((message) => updates(message as Model)) as Model;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Model create() => Model._();
  Model createEmptyInstance() => create();
  static $pb.PbList<Model> createRepeated() => $pb.PbList<Model>();
  @$core.pragma('dart2js:noInline')
  static Model getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Model>(create);
  static Model? _defaultInstance;

  /// i is model id
  @$pb.TagNumber(1)
  $core.String get i => $_getSZ(0);
  @$pb.TagNumber(1)
  set i($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasI() => $_has(0);
  @$pb.TagNumber(1)
  void clearI() => clearField(1);

  /// t is model last update time
  @$pb.TagNumber(2)
  $0.Timestamp get t => $_getN(1);
  @$pb.TagNumber(2)
  set t($0.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasT() => $_has(1);
  @$pb.TagNumber(2)
  void clearT() => clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureT() => $_ensure(1);

  /// d is true mean model has been deleted
  @$pb.TagNumber(3)
  $core.bool get d => $_getBF(2);
  @$pb.TagNumber(3)
  set d($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasD() => $_has(2);
  @$pb.TagNumber(3)
  void clearD() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
