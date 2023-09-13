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

class Person_PersonGender extends $pb.ProtobufEnum {
  static const Person_PersonGender PersonMale = Person_PersonGender._(0, _omitEnumNames ? '' : 'PersonMale');
  static const Person_PersonGender PersonFemale = Person_PersonGender._(1, _omitEnumNames ? '' : 'PersonFemale');

  static const $core.List<Person_PersonGender> values = <Person_PersonGender> [
    PersonMale,
    PersonFemale,
  ];

  static final $core.Map<$core.int, Person_PersonGender> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Person_PersonGender? valueOf($core.int value) => _byValue[value];

  const Person_PersonGender._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
