import 'dart:async';
import 'package:libcli/src/common/region.dart' as region;
import 'package:libcli/configuration.dart';
import 'package:flutter/foundation.dart';

const _here = 'region_web';
inject() => region.get = get;

Future<Regions> get() async {
  debugPrint('$_here~os region is US');
  return Regions.us;
}
