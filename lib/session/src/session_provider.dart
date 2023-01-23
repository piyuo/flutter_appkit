import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as storage;

/// AccessTokenRefresher should use refresh token to exchange new access token, must call loginByRefresh()
typedef AccessTokenRefresher = Future<void> Function(String refreshToken, SessionProvider session);

/// LoginBack should let user log back in, must call login()
typedef LoginBack = Future<void> Function(SessionProvider session);

/// _prefixSession is session key in storage
const _prefixSession = 'session';

/// _prefixSession is session key in storage
const _accessToken = '_AT';

/// _accessTokenExpired is access token expired key in session
const _accessTokenExpired = '_ATE';

/// _refreshToken is refresh token key in session
const _refreshToken = '_RT';

/// _refreshToken is refresh token expired key in session
const _refreshTokenExpired = '_RTE';

class SessionProvider {
  SessionProvider({
    this.onAccessTokenRefresh,
    this.onLoginBack,
    this.onLogout,
  });

  /// onAccessTokenRefresh trigger when access token expired and need refresh, must call loginByRefresh()
  final AccessTokenRefresher? onAccessTokenRefresh;

  /// onLoginBack trigger when access token and refresh token both expired, must call login()
  final LoginBack? onLoginBack;

  /// onLogout trigger when user log out
  final VoidCallback? onLogout;

  /// _data keep session data
  Map<String, dynamic>? _data;

  /// of get SessionProvider from context
  static SessionProvider of(BuildContext context) {
    return Provider.of<SessionProvider>(context, listen: false);
  }

  /// _load load data from storage
  Future<void> _load() async {
    _data = await storage.getMap(_prefixSession);
    _data ??= {};
    var expired = _data![_accessTokenExpired];
    if (expired != null) {
      _data![_accessTokenExpired] = DateTime.fromMillisecondsSinceEpoch(expired);
    }
    expired = _data![_refreshTokenExpired];
    if (expired != null) {
      _data![_refreshTokenExpired] = DateTime.fromMillisecondsSinceEpoch(expired);
    }
  }

  /// _save save data to storage
  Future<void> _save() async {
    if (_data != null && _data!.isNotEmpty) {
      var map = <String, dynamic>{}..addAll(_data!);
      var expired = map[_accessTokenExpired];
      if (expired != null) {
        map[_accessTokenExpired] = expired.millisecondsSinceEpoch;
      }
      expired = map[_refreshTokenExpired];
      if (expired != null) {
        map[_refreshTokenExpired] = expired.millisecondsSinceEpoch;
      }
      await storage.setMap(_prefixSession, map);
      return;
    }
    await storage.delete(_prefixSession);
  }

  /// hasValidAccessToken return true when valid access token is in session
  @visibleForTesting
  bool get hasValidAccessToken {
    final expired = _data![_accessTokenExpired];
    if (expired != null && expired.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  /// hasValidRefreshToken return true when valid refresh token is in session
  @visibleForTesting
  bool get hasValidRefreshToken {
    final expired = _data![_refreshTokenExpired];
    if (expired != null && expired.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  /// isLogin return true if login and session is valid, it will refresh access token if expired
  ///
  ///     var valid = await provide.isLogin();
  ///
  Future<bool> isLogin() async {
    await _load();
    if (hasValidAccessToken) {
      return true;
    }

    if (onAccessTokenRefresh != null && hasValidRefreshToken) {
      await onAccessTokenRefresh!(_data![_refreshToken], this);
      if (hasValidAccessToken) {
        return true;
      }
    }
    if (onLoginBack != null) {
      await onLoginBack!(this);
      if (hasValidAccessToken) {
        return true;
      }
    }
    await logout();
    return false;
  }

  /// getAccessToken return access token if session is valid, it will refresh access token if expired
  ///
  ///     final token = await provide.getAccessToken(context);
  ///
  Future<String?> getAccessToken() async {
    if (await isLogin()) {
      return _data![_accessToken];
    }
    return null;
  }

  /// login to save token
  ///
  ///     await provide.login(
  ///        accessToken: 'fakeAccessToken',
  ///        accessTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
  ///        refreshToken: 'fakeAccessToken',
  ///        refreshTokenExpired: rExpired,
  ///      );
  ///
  Future<void> login({
    required String accessToken,
    required DateTime accessTokenExpired,
    String? refreshToken,
    DateTime? refreshTokenExpired,
  }) async {
    assert(accessToken.isNotEmpty);
    await _load();
    _data![_accessToken] = accessToken;
    _data![_accessTokenExpired] = accessTokenExpired;
    _data![_refreshToken] = refreshToken;
    _data![_refreshTokenExpired] = refreshTokenExpired;
    _save();
  }

  /// loginByRefresh login only refresh access token
  ///
  ///     await session.loginByRefresh(
  ///       accessToken: 'fakeAccessToken2',
  ///       accessTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
  ///     );
  ///
  Future<void> loginByRefresh({
    required String accessToken,
    required DateTime accessTokenExpired,
  }) async {
    assert(accessToken.isNotEmpty);
    await _load();
    _data![_accessToken] = accessToken;
    _data![_accessTokenExpired] = accessTokenExpired;
    _save();
  }

  /// logout session
  ///
  ///     provide.logout();
  ///
  Future<void> logout() async {
    if (onLogout != null) {
      onLogout!();
    }
    _data = {};
    _save();
  }

  /// set value to session
  ///
  ///     await provide.set(context, 'region', 'en');
  ///
  Future<void> set(String key, dynamic value) async {
    if (await isLogin()) {
      _data![key] = value;
      await _save();
    }
  }

  /// get value from session
  ///
  ///     final region = await provide.get(context, 'region');
  ///
  Future<T?> get<T>(String key) async {
    if (await isLogin()) {
      return _data![key];
    }
    return null;
  }
}
