//
//  Generated code. Do not modify.
//  source: login_pin_action.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

/// LoginPinAction is the action to take when a user logs in with a email
/// and verification code
class LoginPinAction extends net.Object {
  $core.int mapIdXXX() => 1025;
  get namespace => 'auth';

  factory LoginPinAction({
    $core.String? email,
    $core.String? pin,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (pin != null) {
      $result.pin = pin;
    }
    return $result;
  }
  LoginPinAction._() : super();
  factory LoginPinAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginPinAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginPinAction', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'pin')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginPinAction clone() => LoginPinAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginPinAction copyWith(void Function(LoginPinAction) updates) => super.copyWith((message) => updates(message as LoginPinAction)) as LoginPinAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginPinAction create() => LoginPinAction._();
  LoginPinAction createEmptyInstance() => create();
  static $pb.PbList<LoginPinAction> createRepeated() => $pb.PbList<LoginPinAction>();
  @$core.pragma('dart2js:noInline')
  static LoginPinAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginPinAction>(create);
  static LoginPinAction? _defaultInstance;

  /// email to verify
  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  /// code is verification code
  @$pb.TagNumber(2)
  $core.String get pin => $_getSZ(1);
  @$pb.TagNumber(2)
  set pin($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPin() => $_has(1);
  @$pb.TagNumber(2)
  void clearPin() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
