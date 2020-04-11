///
//  Generated code. Do not modify.
//  source: analytics_action.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;
import 'package:libcli/command.dart' as command;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package:libcli/command.dart' as $0;

class AnalyticsAction extends command.ProtoObject {
  $core.int mapIdXXX() {
    return 1001;
  }

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('AnalyticsAction', createEmptyInstance: create)
        ..pc<Log>(1, 'logs', $pb.PbFieldType.PM, subBuilder: Log.create)
        ..pc<Error>(2, 'errors', $pb.PbFieldType.PM, subBuilder: Error.create)
        ..hasRequiredFields = false;

  AnalyticsAction._() : super();
  factory AnalyticsAction() => create();
  factory AnalyticsAction.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AnalyticsAction.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  AnalyticsAction clone() => AnalyticsAction()..mergeFromMessage(this);
  AnalyticsAction copyWith(void Function(AnalyticsAction) updates) =>
      super.copyWith((message) => updates(message as AnalyticsAction));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AnalyticsAction create() => AnalyticsAction._();
  AnalyticsAction createEmptyInstance() => create();
  static $pb.PbList<AnalyticsAction> createRepeated() =>
      $pb.PbList<AnalyticsAction>();
  @$core.pragma('dart2js:noInline')
  static AnalyticsAction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnalyticsAction>(create);
  static AnalyticsAction _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Log> get logs => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<Error> get errors => $_getList(1);
}

class Log extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('Log', createEmptyInstance: create)
        ..aOM<$0.Timestamp>(1, 'time', subBuilder: $0.Timestamp.create)
        ..aOS(2, 'msg')
        ..aOS(3, 'user')
        ..aOS(4, 'app')
        ..aOS(5, 'where')
        ..a<$core.int>(6, 'level', $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  Log._() : super();
  factory Log() => create();
  factory Log.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Log.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Log clone() => Log()..mergeFromMessage(this);
  Log copyWith(void Function(Log) updates) =>
      super.copyWith((message) => updates(message as Log));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Log create() => Log._();
  Log createEmptyInstance() => create();
  static $pb.PbList<Log> createRepeated() => $pb.PbList<Log>();
  @$core.pragma('dart2js:noInline')
  static Log getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Log>(create);
  static Log _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($0.Timestamp v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTime() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get user => $_getSZ(2);
  @$pb.TagNumber(3)
  set user($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasUser() => $_has(2);
  @$pb.TagNumber(3)
  void clearUser() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get app => $_getSZ(3);
  @$pb.TagNumber(4)
  set app($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasApp() => $_has(3);
  @$pb.TagNumber(4)
  void clearApp() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get where => $_getSZ(4);
  @$pb.TagNumber(5)
  set where($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasWhere() => $_has(4);
  @$pb.TagNumber(5)
  void clearWhere() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get level => $_getIZ(5);
  @$pb.TagNumber(6)
  set level($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasLevel() => $_has(5);
  @$pb.TagNumber(6)
  void clearLevel() => clearField(6);
}

class Error extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('Error', createEmptyInstance: create)
        ..aOS(1, 'msg')
        ..aOS(2, 'user')
        ..aOS(3, 'app')
        ..aOS(4, 'where')
        ..aOS(5, 'stack')
        ..aOS(6, 'errid')
        ..hasRequiredFields = false;

  Error._() : super();
  factory Error() => create();
  factory Error.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Error.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Error clone() => Error()..mergeFromMessage(this);
  Error copyWith(void Function(Error) updates) =>
      super.copyWith((message) => updates(message as Error));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Error create() => Error._();
  Error createEmptyInstance() => create();
  static $pb.PbList<Error> createRepeated() => $pb.PbList<Error>();
  @$core.pragma('dart2js:noInline')
  static Error getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Error>(create);
  static Error _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msg => $_getSZ(0);
  @$pb.TagNumber(1)
  set msg($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsg() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get user => $_getSZ(1);
  @$pb.TagNumber(2)
  set user($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get app => $_getSZ(2);
  @$pb.TagNumber(3)
  set app($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasApp() => $_has(2);
  @$pb.TagNumber(3)
  void clearApp() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get where => $_getSZ(3);
  @$pb.TagNumber(4)
  set where($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasWhere() => $_has(3);
  @$pb.TagNumber(4)
  void clearWhere() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get stack => $_getSZ(4);
  @$pb.TagNumber(5)
  set stack($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStack() => $_has(4);
  @$pb.TagNumber(5)
  void clearStack() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get errid => $_getSZ(5);
  @$pb.TagNumber(6)
  set errid($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasErrid() => $_has(5);
  @$pb.TagNumber(6)
  void clearErrid() => clearField(6);
}
