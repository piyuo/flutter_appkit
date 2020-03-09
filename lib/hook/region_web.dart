import 'dart:async';
import 'package:libcli/hook/region.dart' as region;
import 'package:libcli/env/env.dart';
import 'package:libcli/log/log.dart';

const _here = 'region_web';
inject() => region.get = get;

Future<Region> get() async {
  '$_here|os region is US'.print;
  return Region.US;
}
