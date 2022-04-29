import 'package:libcli/log/log.dart' as log;

/// Event
class Event {}

/// Contract need listener do something and call complete() when job is done
class Contract extends Event {
  bool _completed = false;
  bool _result = false;

  get isComplete => _completed;

  bool get ok => _result;

  void complete(bool value) {
    log.log('[contract] $runtimeType result=$value');
    _result = value;
    _completed = true;
  }
}

///EmailSupportEvent happen when user click 'Email Us' link
class EmailSupportEvent extends Event {
  EmailSupportEvent();
}
