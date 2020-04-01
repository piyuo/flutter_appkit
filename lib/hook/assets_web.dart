import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:libcli/hook/assets.dart' as assets;
import 'package:flutter/foundation.dart';

const _here = 'assets_web';
inject() => assets.get = get;

Future<String> get(fileName) async {
  debugPrint('$_here|get $fileName');
  return await rootBundle.loadString('assets/$fileName');
}
