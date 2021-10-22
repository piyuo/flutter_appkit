///
//  Generated code. Do not modify.
//  source: cmd-reverse-geocoding.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdReverseGeocoding extends pb.Object {
  $core.int mapIdXXX() => 1003;

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdReverseGeocoding',
      createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lng', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  CmdReverseGeocoding._() : super();
  factory CmdReverseGeocoding({
    $core.double? lat,
    $core.double? lng,
  }) {
    final _result = create();
    if (lat != null) {
      _result.lat = lat;
    }
    if (lng != null) {
      _result.lng = lng;
    }
    return _result;
  }
  factory CmdReverseGeocoding.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CmdReverseGeocoding.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CmdReverseGeocoding clone() => CmdReverseGeocoding()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CmdReverseGeocoding copyWith(void Function(CmdReverseGeocoding) updates) =>
      super.copyWith((message) => updates(message as CmdReverseGeocoding))
          as CmdReverseGeocoding; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CmdReverseGeocoding create() => CmdReverseGeocoding._();
  CmdReverseGeocoding createEmptyInstance() => create();
  static $pb.PbList<CmdReverseGeocoding> createRepeated() => $pb.PbList<CmdReverseGeocoding>();
  @$core.pragma('dart2js:noInline')
  static CmdReverseGeocoding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdReverseGeocoding>(create);
  static CmdReverseGeocoding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double v) {
    $_setDouble(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lng => $_getN(1);
  @$pb.TagNumber(2)
  set lng($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasLng() => $_has(1);
  @$pb.TagNumber(2)
  void clearLng() => clearField(2);
}
