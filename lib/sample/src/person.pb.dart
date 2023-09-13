//
//  Generated code. Do not modify.
//  source: person.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package:libcli/google/src/timestamp.pb.dart' as $1;
import 'package:libcli/net/common/src/model.pb.dart' as $0;
import 'person.pbenum.dart';

export 'person.pbenum.dart';

/// Person object for entity test
class Person extends net.Object {
  $core.int mapIdXXX() => 1001;
  get model => m;
  set model(v) => m = v!;
  get namespace => 'sample';

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
    $core.Iterable<$1.Timestamp>? timestampListValue,
  }) {
    final $result = create();
    if (m != null) {
      $result.m = m;
    }
    if (name != null) {
      $result.name = name;
    }
    if (age != null) {
      $result.age = age;
    }
    if (enumValue != null) {
      $result.enumValue = enumValue;
    }
    if (timestampValue != null) {
      $result.timestampValue = timestampValue;
    }
    if (mapValue != null) {
      $result.mapValue.addAll(mapValue);
    }
    if (stringValue != null) {
      $result.stringValue = stringValue;
    }
    if (int32Value != null) {
      $result.int32Value = int32Value;
    }
    if (floatValue != null) {
      $result.floatValue = floatValue;
    }
    if (doubleValue != null) {
      $result.doubleValue = doubleValue;
    }
    if (boolValue != null) {
      $result.boolValue = boolValue;
    }
    if (stringListValue != null) {
      $result.stringListValue.addAll(stringListValue);
    }
    if (int32ListValue != null) {
      $result.int32ListValue.addAll(int32ListValue);
    }
    if (floatListValue != null) {
      $result.floatListValue.addAll(floatListValue);
    }
    if (doubleListValue != null) {
      $result.doubleListValue.addAll(doubleListValue);
    }
    if (boolListValue != null) {
      $result.boolListValue.addAll(boolListValue);
    }
    if (timestampListValue != null) {
      $result.timestampListValue.addAll(timestampListValue);
    }
    return $result;
  }
  Person._() : super();
  factory Person.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Person.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Person', createEmptyInstance: create)
    ..aOM<$0.Model>(1, _omitFieldNames ? '' : 'm', subBuilder: $0.Model.create)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'age', $pb.PbFieldType.O3)
    ..e<Person_PersonGender>(4, _omitFieldNames ? '' : 'enumValue', $pb.PbFieldType.OE, protoName: 'enumValue', defaultOrMaker: Person_PersonGender.PersonMale, valueOf: Person_PersonGender.valueOf, enumValues: Person_PersonGender.values)
    ..aOM<$1.Timestamp>(5, _omitFieldNames ? '' : 'timestampValue', protoName: 'timestampValue', subBuilder: $1.Timestamp.create)
    ..m<$core.String, $core.int>(6, _omitFieldNames ? '' : 'mapValue', protoName: 'mapValue', entryClassName: 'Person.MapValueEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'stringValue', protoName: 'stringValue')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'int32Value', $pb.PbFieldType.O3, protoName: 'int32Value')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'floatValue', $pb.PbFieldType.OF, protoName: 'floatValue')
    ..a<$core.double>(10, _omitFieldNames ? '' : 'doubleValue', $pb.PbFieldType.OD, protoName: 'doubleValue')
    ..aOB(11, _omitFieldNames ? '' : 'boolValue', protoName: 'boolValue')
    ..pPS(12, _omitFieldNames ? '' : 'stringListValue', protoName: 'stringListValue')
    ..p<$core.int>(13, _omitFieldNames ? '' : 'int32ListValue', $pb.PbFieldType.K3, protoName: 'int32ListValue')
    ..p<$core.double>(14, _omitFieldNames ? '' : 'floatListValue', $pb.PbFieldType.KF, protoName: 'floatListValue')
    ..p<$core.double>(15, _omitFieldNames ? '' : 'doubleListValue', $pb.PbFieldType.KD, protoName: 'doubleListValue')
    ..p<$core.bool>(16, _omitFieldNames ? '' : 'boolListValue', $pb.PbFieldType.KB, protoName: 'boolListValue')
    ..pc<$1.Timestamp>(17, _omitFieldNames ? '' : 'timestampListValue', $pb.PbFieldType.PM, protoName: 'timestampListValue', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Person clone() => Person()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Person copyWith(void Function(Person) updates) => super.copyWith((message) => updates(message as Person)) as Person;

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

  @$pb.TagNumber(17)
  $core.List<$1.Timestamp> get timestampListValue => $_getList(16);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
