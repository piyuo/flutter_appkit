import 'dart:async';
import 'package:libcli/hook/region.dart' as region;
import 'package:libcli/hook/vars.dart';
import 'package:libcli/log/log.dart';

const _here = 'region_main';
inject() => region.get = get;

Future<Regions> get() async {
  '$_here|os region is US'.print;
  return Regions.us;
}
