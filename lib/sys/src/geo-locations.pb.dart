//
//  Generated code. Do not modify.
//  source: geo-locations.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

import 'geo-location.pb.dart' as $0;

///  GeoLocations keep list of geo location result
///
///   result {List<GeoLocation>} list of geo location
class GeoLocations extends net.Object {
  $core.int mapIdXXX() => 1004;
  get namespace => 'sys';

  factory GeoLocations({
    $core.Iterable<$0.GeoLocation>? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result.addAll(result);
    }
    return $result;
  }
  GeoLocations._() : super();
  factory GeoLocations.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeoLocations.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GeoLocations', createEmptyInstance: create)
    ..pc<$0.GeoLocation>(1, _omitFieldNames ? '' : 'result', $pb.PbFieldType.PM, subBuilder: $0.GeoLocation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeoLocations clone() => GeoLocations()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeoLocations copyWith(void Function(GeoLocations) updates) => super.copyWith((message) => updates(message as GeoLocations)) as GeoLocations;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeoLocations create() => GeoLocations._();
  GeoLocations createEmptyInstance() => create();
  static $pb.PbList<GeoLocations> createRepeated() => $pb.PbList<GeoLocations>();
  @$core.pragma('dart2js:noInline')
  static GeoLocations getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeoLocations>(create);
  static GeoLocations? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$0.GeoLocation> get result => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
