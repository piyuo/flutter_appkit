///
//  Generated code. Do not modify.
//  source: person.proto
//
// @dart = 2.12
// ignore_for_file: unnecessary_import, annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package:libcli/pb/src/common/src/model.pb.dart' as $0;
import 'package:libcli/pb/src/google/src/timestamp.pb.dart' as $1;

import 'person.pbenum.dart';

export 'person.pbenum.dart';

class Person extends pb.Object {
  $core.int mapIdXXX() => 1001;
  get hasModel => true;
  get model => m;
  set model(v) => m = v!;
  get namespace => 'sample';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Person', createEmptyInstance: create)
    ..aOM<$0.Model>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'm', subBuilder: $0.Model.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'age', $pb.PbFieldType.O3)
    ..e<Person_PersonGender>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'enumValue', $pb.PbFieldType.OE, protoName: 'enumValue', defaultOrMaker: Person_PersonGender.PersonMale, valueOf: Person_PersonGender.valueOf, enumValues: Person_PersonGender.values)
    ..aOM<$1.Timestamp>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestampValue', protoName: 'timestampValue', subBuilder: $1.Timestamp.create)
    ..m<$core.String, $core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mapValue', protoName: 'mapValue', entryClassName: 'Person.MapValueEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.O3)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stringValue', protoName: 'stringValue')
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'int32Value', $pb.PbFieldType.O3, protoName: 'int32Value')
    ..a<$core.double>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'floatValue', $pb.PbFieldType.OF, protoName: 'floatValue')
    ..a<$core.double>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubleValue', $pb.PbFieldType.OD, protoName: 'doubleValue')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boolValue', protoName: 'boolValue')
    ..pPS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'stringListValue', protoName: 'stringListValue')
    ..p<$core.int>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'int32ListValue', $pb.PbFieldType.P3, protoName: 'int32ListValue')
    ..p<$core.double>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'floatListValue', $pb.PbFieldType.PF, protoName: 'floatListValue')
    ..p<$core.double>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'doubleListValue', $pb.PbFieldType.PD, protoName: 'doubleListValue')
    ..p<$core.bool>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'boolListValue', $pb.PbFieldType.PB, protoName: 'boolListValue')
    ..hasRequiredFields = false
  ;

  Person._() : super();
  factory Person({
    $0.Model? m,
    $core.String? name,
    $core.int? age,
    Person_PersonGender? enumValue,
    $1.Timestamp? timestampValue,
    $core.Map<$core.String, $core.int>? mapValue,
    $core.String? stringValue,
    $core.int? int32Value,
    $core.double? floatValue,
    $core.double? doubleValue,
    $core.bool? boolValue,
    $core.Iterable<$core.String>? stringListValue,
    $core.Iterable<$core.int>? int32ListValue,
    $core.Iterable<$core.double>? floatListValue,
    $core.Iterable<$core.double>? doubleListValue,
    $core.Iterable<$core.bool>? boolListValue,
  }) {
    final _result = create();
    if (m != null) {
      _result.m = m;
    }
    if (name != null) {
      _result.name = name;
    }
    if (age != null) {
      _result.age = age;
    }
    if (enumValue != null) {
      _result.enumValue = enumValue;
    }
    if (timestampValue != null) {
      _result.timestampValue = timestampValue;
    }
    if (mapValue != null) {
      _result.mapValue.addAll(mapValue);
    }
    if (stringValue != null) {
      _result.stringValue = stringValue;
    }
    if (int32Value != null) {
      _result.int32Value = int32Value;
    }
    if (floatValue != null) {
      _result.floatValue = floatValue;
    }
    if (doubleValue != null) {
      _result.doubleValue = doubleValue;
    }
    if (boolValue != null) {
      _result.boolValue = boolValue;
    }
    if (stringListValue != null) {
      _result.stringListValue.addAll(stringListValue);
    }
    if (int32ListValue != null) {
      _result.int32ListValue.addAll(int32ListValue);
    }
    if (floatListValue != null) {
      _result.floatListValue.addAll(floatListValue);
    }
    if (doubleListValue != null) {
      _result.doubleListValue.addAll(doubleListValue);
    }
    if (boolListValue != null) {
      _result.boolListValue.addAll(boolListValue);
    }
    return _result;
  }
  factory Person.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Person.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Person clone() => Person()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Person copyWith(void Function(Person) updates) => super.copyWith((message) => updates(message as Person)) as Person; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Person create() => Person._();
  Person createEmptyInstance() => create();
  static $pb.PbList<Person> createRepeated() => $pb.PbList<Person>();
  @$core.pragma('dart2js:noInline')
  static Person getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Person>(create);
  static Person? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Model get m => $_getN(0);
  @$pb.TagNumber(1)
  set m($0.Model v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasM() => $_has(0);
  @$pb.TagNumber(1)
  void clearM() => clearField(1);
  @$pb.TagNumber(1)
  $0.Model ensureM() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get age => $_getIZ(2);
  @$pb.TagNumber(3)
  set age($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAge() => $_has(2);
  @$pb.TagNumber(3)
  void clearAge() => clearField(3);

  @$pb.TagNumber(4)
  Person_PersonGender get enumValue => $_getN(3);
  @$pb.TagNumber(4)
  set enumValue(Person_PersonGender v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasEnumValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearEnumValue() => clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get timestampValue => $_getN(4);
  @$pb.TagNumber(5)
  set timestampValue($1.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestampValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestampValue() => clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureTimestampValue() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.Map<$core.String, $core.int> get mapValue => $_getMap(5);

  @$pb.TagNumber(7)
  $core.String get stringValue => $_getSZ(6);
  @$pb.TagNumber(7)
  set stringValue($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStringValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearStringValue() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get int32Value => $_getIZ(7);
  @$pb.TagNumber(8)
  set int32Value($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasInt32Value() => $_has(7);
  @$pb.TagNumber(8)
  void clearInt32Value() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get floatValue => $_getN(8);
  @$pb.TagNumber(9)
  set floatValue($core.double v) { $_setFloat(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFloatValue() => $_has(8);
  @$pb.TagNumber(9)
  void clearFloatValue() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get doubleValue => $_getN(9);
  @$pb.TagNumber(10)
  set doubleValue($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDoubleValue() => $_has(9);
  @$pb.TagNumber(10)
  void clearDoubleValue() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get boolValue => $_getBF(10);
  @$pb.TagNumber(11)
  set boolValue($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasBoolValue() => $_has(10);
  @$pb.TagNumber(11)
  void clearBoolValue() => clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.String> get stringListValue => $_getList(11);

  @$pb.TagNumber(13)
  $core.List<$core.int> get int32ListValue => $_getList(12);

  @$pb.TagNumber(14)
  $core.List<$core.double> get floatListValue => $_getList(13);

  @$pb.TagNumber(15)
  $core.List<$core.double> get doubleListValue => $_getList(14);

  @$pb.TagNumber(16)
  $core.List<$core.bool> get boolListValue => $_getList(15);
}

