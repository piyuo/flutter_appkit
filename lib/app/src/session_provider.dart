import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/command.dart' as command;
import 'package:libcli/types/types.dart' as types;
import 'initialize_mixin.dart';

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

/// kSessionUserName is the key for the user name in the session.
const kSessionUserName = 'uName';

/// kSessionUserPhoto is the key for the user photo in the session.
const kSessionUserPhoto = 'uPhoto';

/// kSessionRegion is the key for the region in the session.
const kSessionRegion = 'region';

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

  /// canRefresh return true if there is refresh token and it is valid
  bool get canRefresh => refreshTicket != null && refreshTicket!.isValid;

  /// args can keep extra data like region, language, etc
  Map<String, dynamic> args;

  /// operator [] get args
  operator [](String i) => args[i]; // get

  /// operator []= set args
  operator []=(String i, dynamic value) => args[i] = value; // set

  /// containsKey check if args contains key
  bool containsKey(String key) => args.containsKey(key);

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

  /// remove session from preferences
  static Future<void> remove() async {
    await preferences.remove(_kAccessToken);
    await preferences.remove(_kRefreshToken);
    await preferences.remove(_kArgs);
  }
}

/// SessionProvider keep session and provide session to other widget
class SessionProvider with ChangeNotifier, InitializeMixin {
  SessionProvider({
    required this.loader,
    this.session,
  }) {
    initFuture = () async {
      session = await Session.load();
      debugPrint('$session');
    };

    subscription = eventbus.listen((event) async {
      if (event is command.AccessTokenRevokedEvent) {
        if (session != null) {
          session!.accessTicket.token = '';
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

  /// of get SessionProvider from context
  static SessionProvider of(BuildContext context) {
    return Provider.of<SessionProvider>(context, listen: false);
  }

  late eventbus.Subscription subscription;

  /// loader called when session expired and need refresh
  final SessionLoader loader;

  /// _session is current session, it may not valid if expired, use getValidSession to get valid session
  Session? session;

  /// getValidSession return valid session if valid and it will refresh session if expired
  Future<Session?> getValidSession() async {
    if (session != null && session!.isValid) {
      return session;
    }

    // access token not valid, try load new session
    if (session != null && session!.canRefresh) {
      final refreshTicket = session!.refreshTicket!;
      final newSession = await loader(refreshTicket);
      if (newSession != null) {
        // session get updated
        await login(newSession);
        return session;
      }

      if (newSession == null) {
        await logout();
      }
    }
    return null;
  }

  /// login new session
  /// ```dart
  /// await sessionProvider.login(
  ///    session: Session(),
  ///  );
  /// ```
  Future<void> login(Session newSession) async {
    bool noSession = session == null;
    session = newSession;
    await session!.save();
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
    bool hasSession = session != null;
    session?.accessTicket.token = '';
    session = null;
    await Session.remove();
    if (hasSession) {
      await eventbus.broadcast(LogoutEvent());
    }
    notifyListeners();
  }
}
