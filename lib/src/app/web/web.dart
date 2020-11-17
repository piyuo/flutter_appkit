import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/src/app/configuration.dart' as config;
import 'package:libcli/log.dart';

/// webConfiguration set configuration to web application
///
void webConfiguration({
  required String branch,
  required String appID,
  required String supportEmail,
}) {
  log('web configuration, branch=$branch, appID=$appID, supportEmail=$supportEmail');
  config.branch = branch;
  config.appID = appID;
  config.supportEmail = supportEmail;
  //no need for now, cause GlobalCupertinoLocalizations will load date formatting
//  i18n.initDateFormatting = (String localeID) => initializeDateFormatting(localeID, null);

  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
}
