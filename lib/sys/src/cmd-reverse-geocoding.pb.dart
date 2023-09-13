//
//  Generated code. Do not modify.
//  source: cmd-reverse-geocoding.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do return reverse geocode base on user current gps coordinates
///
/// 	lat {double} user gps latitude
/// 	lng {double} user gps longitude
///
/// 	return {GeoLocations} if success
class CmdReverseGeocoding extends net.Object {
  $core.int mapIdXXX() => 1002;
  get namespace => 'sys';

  factory CmdReverseGeocoding({
    $core.double? lat,
    $core.double? lng,
  }) {
    final $result = create();
    if (lat != null) {
      $result.lat = lat;
    }
    if (lng != null) {
      $result.lng = lng;
    }
    return $result;
  }
  CmdReverseGeocoding._() : super();
  factory CmdReverseGeocoding.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdReverseGeocoding.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdReverseGeocoding', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lng', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdReverseGeocoding clone() => CmdReverseGeocoding()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdReverseGeocoding copyWith(void Function(CmdReverseGeocoding) updates) => super.copyWith((message) => updates(message as CmdReverseGeocoding)) as CmdReverseGeocoding;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CmdReverseGeocoding create() => CmdReverseGeocoding._();
  CmdReverseGeocoding createEmptyInstance() => create();
  static $pb.PbList<CmdReverseGeocoding> createRepeated() => $pb.PbList<CmdReverseGeocoding>();
  @$core.pragma('dart2js:noInline')
  static CmdReverseGeocoding getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdReverseGeocoding>(create);
  static CmdReverseGeocoding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get lat => $_getN(0);
  @$pb.TagNumber(1)
  set lat($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLat() => $_has(0);
  @$pb.TagNumber(1)
  void clearLat() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lng => $_getN(1);
  @$pb.TagNumber(2)
  set lng($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLng() => $_has(1);
  @$pb.TagNumber(2)
  void clearLng() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
