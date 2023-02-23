import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/command/command.dart' as command;
import 'initialize_mixin.dart';

/// LoginEvent is event when user login through UI
class LoginEvent {}

/// LogoutEvent is event when user logout
class LogoutEvent {}

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

/// _kTokenValue is token value key
const _kTokenValue = 'V';

/// _kTokenExpired is token expired key
const _kTokenExpired = 'E';

/// kSessionUserName is the key for the user name in the session.
const kSessionUserName = 'uName';

/// kSessionUserPhoto is the key for the user photo in the session.
const kSessionUserPhoto = 'uPhoto';

/// kSessionRegion is the key for the region in the session.
const kSessionRegion = 'region';

/// Token keep value and expired time
class Token {
  Token({
    required this.value,
    required this.expired,
  });

  /// value is access token value or refresh token value
  String value;

  /// expired is access key expired time
  DateTime expired;

  /// isValid check if token is valid
  bool get isValid => value.isNotEmpty && expired.isAfter(DateTime.now());

  /// save save token to storage
  Future<void> save(String prefix) async {
    await preferences.setMap(prefix, {
      _kTokenValue: value,
      _kTokenExpired: expired.millisecondsSinceEpoch,
    });
  }

  /// load load token from storage
  static Future<Token?> load(String prefix) async {
    final data = await preferences.getMap(prefix);
    if (data != null) {
      return Token(
        value: data[_kTokenValue],
        expired: DateTime.fromMillisecondsSinceEpoch(data[_kTokenExpired]),
      );
    }
    return null;
  }
}

/// Session keep access token, refresh token and extra data
class Session {
  Session({
    required this.accessToken,
    this.refreshToken,
    this.args = const {},
  });

  /// accessToken keep access token value and expired time
  Token accessToken;

  /// refreshToken keep refresh token value and expired time
  Token? refreshToken;

  /// isValid return true if access token is valid
  bool get isValid => accessToken.isValid;

  /// canRefresh return true if there is refresh token and it is valid
  bool get canRefresh => refreshToken != null && refreshToken!.isValid;

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
          session!.accessToken.value = '';
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
      final refreshToken = session!.refreshToken!;
      final newSession = await loader(refreshToken);
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
    session?.accessToken.value = '';
    session = null;
    await Session.remove();
    if (hasSession) {
      await eventbus.broadcast(LogoutEvent());
    }
    notifyListeners();
  }
}
