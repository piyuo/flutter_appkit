//
//  Generated code. Do not modify.
//  source: person.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Person_Gender extends $pb.ProtobufEnum {
  static const Person_Gender GENDER_UNSPECIFIED = Person_Gender._(0, _omitEnumNames ? '' : 'GENDER_UNSPECIFIED');
  static const Person_Gender GENDER_MALE = Person_Gender._(1, _omitEnumNames ? '' : 'GENDER_MALE');
  static const Person_Gender GENDER_FEMALE = Person_Gender._(2, _omitEnumNames ? '' : 'GENDER_FEMALE');

  static const $core.List<Person_Gender> values = <Person_Gender> [
    GENDER_UNSPECIFIED,
    GENDER_MALE,
    GENDER_FEMALE,
  ];

  static final $core.Map<$core.int, Person_Gender> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Person_Gender? valueOf($core.int value) => _byValue[value];

  const Person_Gender._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
