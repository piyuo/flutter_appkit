import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/command.dart' as command;

/// LoginEvent is event when user login through UI
class LoginEvent {}

/// LogoutEvent is event when user logout
class LogoutEvent {}

/// SessionLoader called when session expired,
/// you should use refresh key to exchange new access token, or display UI to let user log back in
/// return null if you want to logout, or return new session
typedef SessionLoader = Future<Session?> Function(Ticket? refreshTicket);

/// _kAccessToken is access token key in preferences
const _kAccessToken = 'A';

/// _kRefreshToken is refresh token key in preferences
const _kRefreshToken = 'R';

/// _kArgs is args key in preferences
const _kArgs = 'G';

/// _kTicketToken is token key
const _kTicketToken = 'T';

/// _kTicketExpired is expired key
const _kTicketExpired = 'E';

/// Ticket keep token and expired time
class Ticket {
  Ticket({
    required this.token,
    required this.expired,
  });

  /// token is access token or refresh token
  String token;

  /// expired is access key expired time
  DateTime expired;

  /// isValid check if token is valid
  bool get isValid => token.isNotEmpty && expired.isAfter(DateTime.now());

  /// save save token to storage
  Future<void> save(String prefix) async {
    await preferences.setMap(prefix, {
      _kTicketToken: token,
      _kTicketExpired: expired.millisecondsSinceEpoch,
    });
  }

  /// load load token from storage
  static Future<Ticket?> load(String prefix) async {
    final data = await preferences.getMap(prefix);
    if (data != null) {
      return Ticket(
        token: data[_kTicketToken],
        expired: DateTime.fromMillisecondsSinceEpoch(data[_kTicketExpired]),
      );
    }
    return null;
  }
}

/// Session keep access token, refresh token and extra data
class Session {
  Session({
    required this.accessTicket,
    this.refreshTicket,
    this.args = const {},
  });

  /// accessTicket key access token and expired time
  Ticket accessTicket;

  /// refreshTicket keep refresh token and expired time
  Ticket? refreshTicket;

  /// isValid return true if access token is valid
  bool get isValid => accessTicket.isValid;

  /// args can keep extra data like region, language, etc
  Map<String, dynamic> args;

  /// operator [] get args
  operator [](String i) => args[i]; // get

  /// operator []= set args
  operator []=(String i, dynamic value) => args[i] = value; // set

  /// save session to preferences
  Future<void> save() async {
    await accessTicket.save(_kAccessToken);
    if (refreshTicket != null) {
      await refreshTicket!.save(_kRefreshToken);
    }
    if (args.isNotEmpty) {
      await preferences.setMap(_kArgs, args);
    }
  }

  /// load session from preferences
  static Future<Session?> load() async {
    final accessTicket = await Ticket.load(_kAccessToken);
    if (accessTicket != null) {
      return Session(
        accessTicket: accessTicket,
        refreshTicket: await Ticket.load(_kRefreshToken),
        args: await preferences.getMap(_kArgs) ?? {},
      );
    }
    return null;
  }

  /// delete session from preferences
  static Future<void> delete() async {
    await preferences.delete(_kAccessToken);
    await preferences.delete(_kRefreshToken);
    await preferences.delete(_kArgs);
  }
}

/// SessionProvider keep session and provide session to other widget
class SessionProvider with ChangeNotifier {
  SessionProvider({
    required this.loader,
  }) {
    subscription = eventbus.listen((event) async {
      if (event is command.AccessTokenRevokedEvent) {
        if (_session != null) {
          _session!.accessTicket.token = '';
        }
      }
      if (event is command.ForceLogOutEvent) {
        await logout();
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  late eventbus.Subscription subscription;

  /// loader called when session expired and need refresh
  final SessionLoader loader;

  /// _session is session
  Session? _session;

  /// of get SessionProvider from context
  static SessionProvider of(BuildContext context) {
    return Provider.of<SessionProvider>(context, listen: false);
  }

  /// _load load data from storage
  Future<void> load() async {
    _session = await Session.load();
  }

  /// session return session if valid
  Future<Session?> get session async {
    if (_session != null && _session!.isValid) {
      return _session;
    }

    // access token not valid, try load new session
    final refreshTicket = _session != null && _session!.refreshTicket != null && _session!.refreshTicket!.isValid
        ? _session!.refreshTicket!
        : null;
    final newSession = await loader(refreshTicket);
    if (newSession == null) {
      // logout
      if (_session != null) {
        await logout();
      }
      return null;
    }

    // session get updated
    await login(newSession);
    return _session;
  }

  /// login new session
  /// ```dart
  /// await sessionProvider.login(
  ///    session: Session(),
  ///  );
  /// ```
  Future<void> login(Session session) async {
    bool noSession = _session == null;
    _session = session;
    await _session!.save();
    if (noSession) {
      await eventbus.broadcast(LoginEvent());
    }
    notifyListeners();
  }

  /// logout session
  /// ```dart
  /// sessionProvider.logout();
  /// ```
  Future<void> logout() async {
    bool hasSession = _session != null;
    _session?.accessTicket.token = '';
    _session = null;
    await Session.delete();
    if (hasSession) {
      await eventbus.broadcast(LogoutEvent());
    }
    notifyListeners();
  }
}
