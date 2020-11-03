import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/log.dart';
import 'package:libcli/i18n.dart' as i18n;
import 'package:libcli/src/app/configuration.dart' as config;
import 'package:intl/date_symbol_data_local.dart';

/// nativeConfiguration set configuration to native application
///
void nativeConfiguration({
  @required String branch,
  @required String appID,
  @required String supportEmail,
}) {
  debugPrint('native configuration, branch=$branch, appID=$appID, supportEmail=$supportEmail');
  config.branch = branch;
  config.appID = appID;
  config.supportEmail = supportEmail;
  //no need for now, cause GlobalCupertinoLocalizations will load date formatting
//  i18n.initDateFormatting = (String localeID) => initializeDateFormatting(localeID, null);

  debugPrint = overrideDebugPrint;
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
}
