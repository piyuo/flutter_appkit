//
//  Generated code. Do not modify.
//  source: resend_pin_action.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

/// ResendPinAction is the action to resend the verification code to the user
/// return SendPinResponse
class ResendPinAction extends net.Object {
  $core.int mapIdXXX() => 1030;
  get namespace => 'auth';

  factory ResendPinAction({
    $core.String? email,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    return $result;
  }
  ResendPinAction._() : super();
  factory ResendPinAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResendPinAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResendPinAction', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResendPinAction clone() => ResendPinAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResendPinAction copyWith(void Function(ResendPinAction) updates) => super.copyWith((message) => updates(message as ResendPinAction)) as ResendPinAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResendPinAction create() => ResendPinAction._();
  ResendPinAction createEmptyInstance() => create();
  static $pb.PbList<ResendPinAction> createRepeated() => $pb.PbList<ResendPinAction>();
  @$core.pragma('dart2js:noInline')
  static ResendPinAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResendPinAction>(create);
  static ResendPinAction? _defaultInstance;

  /// email is the email address of the user
  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
