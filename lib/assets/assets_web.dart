import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:libcli/assets/assets.dart' as assets;
import 'package:libcli/log/log.dart';

const _here = 'assets_web';
inject() => assets.get = get;

Future<String> get(fileName) async {
  '$_here|get $fileName'.print;
  return await rootBundle.loadString('assets/$fileName');
}
