import 'dart:async';
import 'package:libcli/hook/vars.dart' as vars;

typedef Future<vars.Regions> Get();

/// get region from os or browser
///
Get get;
