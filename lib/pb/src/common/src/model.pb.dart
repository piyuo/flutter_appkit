///
//  Generated code. Do not modify.
//  source: model.proto
//
// @dart = 2.12
// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

// ignore: implementation_imports
import 'package:libcli/google/src/timestamp.pb.dart' as $0;

class Model extends pb.Object {
  $core.int mapIdXXX() => 3;
  get namespace => 'common';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Model', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'i')
    ..aOM<$0.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 't', subBuilder: $0.Timestamp.create)
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'd')
    ..hasRequiredFields = false
  ;

  Model._() : super();
  factory Model({
    $core.String? i,
    $0.Timestamp? t,
    $core.bool? d,
  }) {
    final _result = create();
    if (i != null) {
      _result.i = i;
    }
    if (t != null) {
      _result.t = t;
    }
    if (d != null) {
      _result.d = d;
    }
    return _result;
  }
  factory Model.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Model.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Model clone() => Model()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Model copyWith(void Function(Model) updates) => super.copyWith((message) => updates(message as Model)) as Model; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Model create() => Model._();
  Model createEmptyInstance() => create();
  static $pb.PbList<Model> createRepeated() => $pb.PbList<Model>();
  @$core.pragma('dart2js:noInline')
  static Model getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Model>(create);
  static Model? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get i => $_getSZ(0);
  @$pb.TagNumber(1)
  set i($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasI() => $_has(0);
  @$pb.TagNumber(1)
  void clearI() => clearField(1);

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

  @$pb.TagNumber(3)
  $core.bool get d => $_getBF(2);
  @$pb.TagNumber(3)
  set d($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasD() => $_has(2);
  @$pb.TagNumber(3)
  void clearD() => clearField(3);
}

