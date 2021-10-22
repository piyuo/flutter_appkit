// ignore_for_file: annotate_overrides

import 'package:protobuf/protobuf.dart' as $pb;
import 'dart:core' as $core;
import 'object.dart';

/// empty is an empty proto object
///
///     return ProtoObject.empty;
///
final empty = Empty();

class Empty extends Object {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty',
      createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false;
  static Empty create() => Empty();
  $core.int mapIdXXX() => 0;
  Empty clone() => this;
  Empty copyWith(void Function(Empty) updates) => this; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  Empty createEmptyInstance() => this;
}
