//
//  Generated code. Do not modify.
//  source: send_pin_response.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

import 'send_pin_response.pbenum.dart';

export 'send_pin_response.pbenum.dart';

/// / SendPinResponse is response for [ResendPinAction] and [VerifyPinAction].
class SendPinResponse extends net.Object {
  $core.int mapIdXXX() => 1032;
  get namespace => 'auth';

  factory SendPinResponse({
    SendPinResponse_Result? result,
  }) {
    final $result = create();
    if (result != null) {
      $result.result = result;
    }
    return $result;
  }
  SendPinResponse._() : super();
  factory SendPinResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SendPinResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SendPinResponse', createEmptyInstance: create)
    ..e<SendPinResponse_Result>(1, _omitFieldNames ? '' : 'result', $pb.PbFieldType.OE, defaultOrMaker: SendPinResponse_Result.RESULT_UNSPECIFIED, valueOf: SendPinResponse_Result.valueOf, enumValues: SendPinResponse_Result.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SendPinResponse clone() => SendPinResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SendPinResponse copyWith(void Function(SendPinResponse) updates) => super.copyWith((message) => updates(message as SendPinResponse)) as SendPinResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SendPinResponse create() => SendPinResponse._();
  SendPinResponse createEmptyInstance() => create();
  static $pb.PbList<SendPinResponse> createRepeated() => $pb.PbList<SendPinResponse>();
  @$core.pragma('dart2js:noInline')
  static SendPinResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SendPinResponse>(create);
  static SendPinResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SendPinResponse_Result get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(SendPinResponse_Result v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
