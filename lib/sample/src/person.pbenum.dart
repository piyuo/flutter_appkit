///
//  Generated code. Do not modify.
//  source: person.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class Person_PersonGender extends $pb.ProtobufEnum {
  static const Person_PersonGender PersonMale = Person_PersonGender._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PersonMale');
  static const Person_PersonGender PersonFemale = Person_PersonGender._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PersonFemale');

  static const $core.List<Person_PersonGender> values = <Person_PersonGender> [
    PersonMale,
    PersonFemale,
  ];

  static final $core.Map<$core.int, Person_PersonGender> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Person_PersonGender? valueOf($core.int value) => _byValue[value];

  const Person_PersonGender._($core.int v, $core.String n) : super(v, n);
}

