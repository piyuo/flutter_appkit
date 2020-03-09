import 'dart:async';
import 'package:libcli/env/env.dart';

typedef Future<Region> Get();

/// get region from os or browser
///
Get get;
