import 'package:flutter/widgets.dart';
import 'package:libcli/src/i18n/global.dart';
import 'package:libcli/src/i18n/time.dart';
import 'package:libpb/google.dart' as google;
import 'package:protobuf/src/protobuf/mixins/well_known.dart' as googleMixin;
import 'package:provider/provider.dart';
import 'package:libcli/src/i18n/provider.dart';

/// I18nLocalization add localization function to string
///
extension I18nLocalization on String {
  String get i18n_ {
    return globalTranslate(this);
  }

  String i18n(BuildContext context) {
    var provider = Provider.of<I18nProvider>(context, listen: false);
    return provider.translate(this);
  }
}

/// timestamp create TimpStamp and convert datetime to utc, if datetime is null use DateTime.now()
///
google.Timestamp timestamp({
  DateTime? datetime,
}) {
  datetime = datetime ?? DateTime.now();
  return google.Timestamp.fromDateTime(datetime.toUtc());
}

/// I18nTime add time function to TimeStamp
///
extension I18nTime on google.Timestamp {
  /// local return local datetime
  ///
  DateTime get local {
    return toDateTime().toLocal();
  }

  /// local set local datetime
  ///
  void set local(DateTime d) {
    googleMixin.TimestampMixin.setFromDateTime(this, d.toUtc());
  }

  /// localDateString return local date string in current locale
  ///
  String get localDateString {
    return dateToStr(local);
  }

  /// localDateTimeString return local date time string in current locale
  ///
  String get localDateTimeString {
    return datetimeToStr(local);
  }

  /// localDateString return local time string in current locale
  ///
  String get localTimeString {
    return timeToStr(local);
  }
}
