///
//  Generated code. Do not modify.
//  source: geo-locations.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libpb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

import 'geo-location.pb.dart' as $0;

class GeoLocations extends pb.Object {
  $core.int mapIdXXX() {
    return 1010;
  }
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GeoLocations', createEmptyInstance: create)
    ..pc<$0.GeoLocation>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', $pb.PbFieldType.PM, subBuilder: $0.GeoLocation.create)
    ..hasRequiredFields = false
  ;

  GeoLocations._() : super();
  factory GeoLocations({
    $core.Iterable<$0.GeoLocation>? result,
  }) {
    final _result = create();
    if (result != null) {
      _result.result.addAll(result);
    }
    return _result;
  }
  factory GeoLocations.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeoLocations.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeoLocations clone() => GeoLocations()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeoLocations copyWith(void Function(GeoLocations) updates) => super.copyWith((message) => updates(message as GeoLocations)) as GeoLocations; // ignore: deprecated_member_use
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

