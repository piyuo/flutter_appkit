import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log.dart';
import 'package:libcli/i18n.dart' as i18n;

import 'package:libcli/src/configuration/configuration.dart' as config;
import 'package:intl/date_symbol_data_http_request.dart';

/// webConfiguration set configuration to web application
///
Future<void> webConfiguration({
  @required branch,
  @required appID,
  @required supportEmail,
}) async {
  debugPrint('web app, branch=$branch, appID=$appID, supportEmail=$supportEmail');
  config.branch = branch;
  config.appID = appID;
  config.supportEmail = supportEmail;
  i18n.initDateFormatting = (String localeID) => initializeDateFormatting(localeID, null);

  debugPrint = overrideDebugPrint;
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
}
