///
//  Generated code. Do not modify.
//  source: cmd-subdomain-available.proto
//
// @dart = 2.12
// ignore_for_file: constant_identifier_names,depend_on_referenced_packages,no_leading_underscores_for_local_identifiers,unnecessary_import, annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'package:libcli/pb/pb.dart' as pb;

import 'package:protobuf/protobuf.dart' as $pb;

class CmdSubdomainAvailable extends pb.Object {
  $core.int mapIdXXX() => 1009;
  get namespace => 'auth';

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CmdSubdomainAvailable', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'subDomain', protoName: 'subDomain')
    ..hasRequiredFields = false
  ;

  CmdSubdomainAvailable._() : super();
  factory CmdSubdomainAvailable({
    $core.String? subDomain,
  }) {
    final _result = create();
    if (subDomain != null) {
      _result.subDomain = subDomain;
    }
    return _result;
  }
  factory CmdSubdomainAvailable.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSubdomainAvailable.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSubdomainAvailable clone() => CmdSubdomainAvailable()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSubdomainAvailable copyWith(void Function(CmdSubdomainAvailable) updates) => super.copyWith((message) => updates(message as CmdSubdomainAvailable)) as CmdSubdomainAvailable; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CmdSubdomainAvailable create() => CmdSubdomainAvailable._();
  CmdSubdomainAvailable createEmptyInstance() => create();
  static $pb.PbList<CmdSubdomainAvailable> createRepeated() => $pb.PbList<CmdSubdomainAvailable>();
  @$core.pragma('dart2js:noInline')
  static CmdSubdomainAvailable getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CmdSubdomainAvailable>(create);
  static CmdSubdomainAvailable? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subDomain => $_getSZ(0);
  @$pb.TagNumber(1)
  set subDomain($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSubDomain() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubDomain() => clearField(1);
}

