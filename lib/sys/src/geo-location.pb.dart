//
//  Generated code. Do not modify.
//  source: geo-location.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  GeoLocation keep geo location information
///
/// 	address {string} is location address, like '1 apple park, irvine, ca 92618'
/// 	lat {double} is location latitude
/// 	lng {double} is location longitude
/// 	tags {[]string} address tags for analytic
/// 	country {string} country code of this location like 'US', 'AU'
class GeoLocation extends net.Object {
  $core.int mapIdXXX() => 1003;
  get namespace => 'sys';

  factory GeoLocation({
    $core.String? address,
    $core.double? lat,
    $core.double? lng,
    $core.Iterable<$core.String>? tags,
    $core.String? country,
  }) {
    final $result = create();
    if (address != null) {
      $result.address = address;
    }
    if (lat != null) {
      $result.lat = lat;
    }
    if (lng != null) {
      $result.lng = lng;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (country != null) {
      $result.country = country;
    }
    return $result;
  }
  GeoLocation._() : super();
  factory GeoLocation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeoLocation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GeoLocation', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'address')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lat', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'lng', $pb.PbFieldType.OD)
    ..pPS(4, _omitFieldNames ? '' : 'tags')
    ..aOS(5, _omitFieldNames ? '' : 'country')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeoLocation clone() => GeoLocation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeoLocation copyWith(void Function(GeoLocation) updates) => super.copyWith((message) => updates(message as GeoLocation)) as GeoLocation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeoLocation create() => GeoLocation._();
  GeoLocation createEmptyInstance() => create();
  static $pb.PbList<GeoLocation> createRepeated() => $pb.PbList<GeoLocation>();
  @$core.pragma('dart2js:noInline')
  static GeoLocation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoLocation>(create);
  static GeoLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get lat => $_getN(1);
  @$pb.TagNumber(2)
  set lat($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLat() => $_has(1);
  @$pb.TagNumber(2)
  void clearLat() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get lng => $_getN(2);
  @$pb.TagNumber(3)
  set lng($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLng() => $_has(2);
  @$pb.TagNumber(3)
  void clearLng() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.String> get tags => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get country => $_getSZ(4);
  @$pb.TagNumber(5)
  set country($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCountry() => $_has(4);
  @$pb.TagNumber(5)
  void clearCountry() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
