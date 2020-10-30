import 'package:intl/date_symbol_data_local.dart';

/// timeToString convert hour and minute to local string
///
Future<String> timeToString(int hour, int minute) async {
  await initializeDateFormatting('fr_FR', null);

}
