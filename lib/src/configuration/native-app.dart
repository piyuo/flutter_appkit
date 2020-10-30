import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log.dart';
import 'package:libcli/src/configuration/configuration.dart' as config;
import 'package:intl/date_symbol_data_local.dart';

/// nativeConfiguration set configuration to native application
///
Future<void> nativeConfiguration({
  @required branch,
  @required appID,
  @required supportEmail,
}) async {
  debugPrint('native app, branch=$branch, appID=$appID, supportEmail=$supportEmail');
  config.branch = branch;
  config.appID = appID;
  config.supportEmail = supportEmail;
  config.initDateFormatting = (String localeID) => initializeDateFormatting(localeID, null);

  debugPrint = overrideDebugPrint;
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
}
