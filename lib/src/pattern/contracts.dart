import 'package:libcli/eventbus.dart';
import 'package:libcli/log.dart' as log;

///EmailSupportContract happen when user click 'Email Us' link on await error message
///
class EmailSupportContract extends Contract {
  final List<log.ErrorReport> reports;
  EmailSupportContract(this.reports);
}
