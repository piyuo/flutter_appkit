import 'package:flutter/widgets.dart';
import 'package:libcli/src/pb/google/google.dart' as google;
// ignore: implementation_imports
import 'package:protobuf/src/protobuf/mixins/well_known.dart' as google_mixin;
import 'package:provider/provider.dart';
import 'package:libcli/src/i18n/i18n_provider.dart';
import 'package:libcli/src/i18n/predefine.dart';
import 'package:libcli/src/i18n/time.dart';

/// I18nLocalization add localization function to string
///
extension I18nLocalization on String {
  /// i18n_ translate const string defined in global dict, don't use this method on string variable
  ///
  ///   'ERROR'.i18n_; // OK
  ///
  ///   var err='ERROR';
  ///   err.i18n_; // Not OK
  ///
  String get i18n_ {
    return predefine(this);
  }

  /// i18n translate const string, don't use this method on string variable
  ///
  ///   'ERROR'.i18n(context); // OK
  ///
  ///   var err='ERROR';
  ///   err.i18n(context); // Not OK
  ///
  String i18n(BuildContext context) {
    var provider = Provider.of<I18nProvider>(context, listen: false);
    return provider.translate(this);
  }
}

/// i18n_ translate str base on current locale
///
String i18n_(String str) {
  return predefine(str);
}

/// i18n translate string base on current locale
///
String i18n(BuildContext context, String str) {
  var provider = Provider.of<I18nProvider>(context, listen: false);
  return provider.translate(str);
}

/// timestamp create TimeStamp and convert datetime to utc, if datetime is null use DateTime.now()
///
///      var t = timestamp();
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
  ///     var d = DateTime(2021, 1, 2, 23, 30);
  ///     var t = timestamp();
  ///     t.local = d;
  ///     expect(t.local, d);
  ///
  DateTime get local {
    return toDateTime().toLocal();
  }

  /// local set local datetime
  ///
  ///     var d = DateTime(2021, 1, 2, 23, 30);
  ///     var t = timestamp();
  ///     t.local = d;
  ///     expect(t.local, d);
  ///
  set local(DateTime d) {
    google_mixin.TimestampMixin.setFromDateTime(this, d.toUtc());
  }

  /// localDateString return local date string in current locale
  ///
  ///     expect(t.localDateString, 'Jan 2, 2021');
  ///
  String get localDateString {
    return dateToStr(local);
  }

  /// localDateTimeString return local date time string in current locale
  ///
  ///     expect(t.localTimeString, '11:30 PM');
  ///
  String get localDateTimeString {
    return datetimeToStr(local);
  }

  /// localDateString return local time string in current locale
  ///
  ///     expect(t.localDateTimeString, 'Jan 2, 2021 11:30 PM');
  ///
  String get localTimeString {
    return timeToStr(local);
  }
}
