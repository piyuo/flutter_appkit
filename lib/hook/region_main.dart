import 'dart:async';
import 'package:libcli/hook/region.dart' as region;
import 'package:libcli/hook/vars.dart';
import 'package:flutter/foundation.dart';

const _here = 'region_main';
inject() => region.get = get;

Future<Regions> get() async {
  debugPrint('$_here|os region is US');
  return Regions.us;
}
