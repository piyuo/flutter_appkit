import 'dart:async';
import 'package:libcli/configuration.dart' as configuration;

typedef Future<configuration.Regions> Get();

/// get region from os or browser
///
Get get;
