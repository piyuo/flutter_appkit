//
//  Generated code. Do not modify.
//  source: cmd-subdomain-available.proto
//
// @dart = 2.12

// ignore_for_file: depend_on_referenced_packages,no_leading_underscores_for_local_identifiers, annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;
import 'package:libcli/net/net.dart' as net;

import 'package:protobuf/protobuf.dart' as $pb;

///  Do check sub domain is available
///
/// 	SubDomain {string} is piyuo.com sub domain name, like example
///
/// 	return {PbBool} true if domain is available
/// 	return DOMAIN_INVALID {PbError} if domain is invalid
class CmdSubdomainAvailable extends net.Object {
  $core.int mapIdXXX() => 1009;
  get namespace => 'auth';

  factory CmdSubdomainAvailable({
    $core.String? subDomain,
  }) {
    final $result = create();
    if (subDomain != null) {
      $result.subDomain = subDomain;
    }
    return $result;
  }
  CmdSubdomainAvailable._() : super();
  factory CmdSubdomainAvailable.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CmdSubdomainAvailable.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CmdSubdomainAvailable', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subDomain', protoName: 'subDomain')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CmdSubdomainAvailable clone() => CmdSubdomainAvailable()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CmdSubdomainAvailable copyWith(void Function(CmdSubdomainAvailable) updates) => super.copyWith((message) => updates(message as CmdSubdomainAvailable)) as CmdSubdomainAvailable;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
