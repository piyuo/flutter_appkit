import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'app.dart';

/// LoginEvent is event when user login through UI
class LoginEvent extends eventbus.Event {}

/// LogoutEvent is event when user logout
class LogoutEvent extends eventbus.Event {}

/// SessionLoader called when session expired,
/// you should use refresh key to exchange new access token, or display UI to let user log back in
/// return null if you want to logout, or return new session
typedef SessionLoader = Future<Session?> Function(Token? refreshToken);

/// _kAccessToken is access token key in preferences
const _kAccessToken = 'A';

/// _kRefreshToken is refresh token key in preferences
const _kRefreshToken = 'R';

/// _kArgs is args key in preferences
const _kArgs = 'G';

/// _kTokenKey is token key
const _kTokenKey = 'K';

/// _kTokenExpired is token key
const _kTokenExpired = 'E';

class Token {
  Token({
    required this.key,
    required this.expired,
  });

  /// key is access key
  String key;

  /// expired is access key expired time
  DateTime expired;

  /// isValid check if token is valid
  bool get isValid => expired.isAfter(DateTime.now());

  /// save save token to storage
  Future<void> save(String prefix) async {
    await preferences.setMap(prefix, {
      _kTokenKey: key,
      _kTokenExpired: expired.millisecondsSinceEpoch,
    });
  }

  /// load load token from storage
  static Future<Token?> load(String prefix) async {
    final data = await preferences.getMap(prefix);
    if (data != null) {
      return Token(
        key: data[_kTokenKey],
        expired: DateTime.fromMillisecondsSinceEpoch(data[_kTokenExpired]),
      );
    }
    return null;
  }
}

class Session {
  Session({
    required this.accessToken,
    this.refreshToken,
    this.args = const {},
  });

  /// accessToken is access token
  Token accessToken;

  /// _refreshToken is refresh token
  Token? refreshToken;

  /// isValid return true if access token is valid
  bool get isValid => accessToken.isValid;

  /// args can keep extra data like region, language, etc
  Map<String, dynamic> args;

  /// operator [] get args
  operator [](String i) => args[i]; // get

  /// operator []= set args
  operator []=(String i, dynamic value) => args[i] = value; // set

  /// save session to preferences
  Future<void> save() async {
    await accessToken.save(_kAccessToken);
    if (refreshToken != null) {
      await refreshToken!.save(_kRefreshToken);
    }
    if (args.isNotEmpty) {
      await preferences.setMap(_kArgs, args);
    }
  }

  /// load session from preferences
  static Future<Session?> load() async {
    final accessToken = await Token.load(_kAccessToken);
    if (accessToken != null) {
      return Session(
        accessToken: accessToken,
        refreshToken: await Token.load(_kRefreshToken),
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

class SessionProvider extends AppProvider {
  SessionProvider({
    required this.loader,
  });

  /// loader called when session expired and need refresh
  final SessionLoader loader;

  /// _session is session
  Session? _session;

  /// of get SessionProvider from context
  static SessionProvider of(BuildContext context) {
    return Provider.of<SessionProvider>(context, listen: false);
  }

  /// _load load data from storage
  @override
  Future<void> load() async {
    _session = await Session.load();
  }

  /// session return session if valid
  Future<Session?> get session async {
    if (_session != null && _session!.isValid) {
      return _session;
    }

    // access token not valid, try load new session
    final refreshToken = _session != null && _session!.refreshToken != null && _session!.refreshToken!.isValid
        ? _session!.refreshToken!
        : null;
    final newSession = await loader(refreshToken);
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
    _session = null;
    await Session.delete();
    if (hasSession) {
      await eventbus.broadcast(LogoutEvent());
    }
    notifyListeners();
  }
}
