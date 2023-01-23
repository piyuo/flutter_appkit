import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:libcli/preferences/preferences.dart' as preferences;

/// AccessTokenRefresher should use refresh token to exchange new access token, must call loginByRefresh()
typedef AccessTokenRefresher = Future<void> Function(String refreshToken, SessionProvider session);

/// LoginBack should let user log back in, must call login()
typedef LoginBack = Future<void> Function(SessionProvider session);

/// _kSessionKey is session key in storage
const _kSessionKey = '_S';

/// _kAccessTokenKey is access token key in storage
const _kAccessTokenKey = '_A';

/// _kAccessTokenExpiredKey is access token expired key to track when access token expired
const _kAccessTokenExpiredKey = '_AE';

/// _kRefreshTokenKey is refresh token key in session
const _kRefreshTokenKey = '_R';

/// _kRefreshTokenExpiredKey is refresh token expired key to track when refresh token expired
const _kRefreshTokenExpiredKey = '_RE';

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
    _data = await preferences.getMap(_kSessionKey);
    _data ??= {};
    var expired = _data![_kAccessTokenExpiredKey];
    if (expired != null) {
      _data![_kAccessTokenExpiredKey] = DateTime.fromMillisecondsSinceEpoch(expired);
    }
    expired = _data![_kRefreshTokenExpiredKey];
    if (expired != null) {
      _data![_kRefreshTokenExpiredKey] = DateTime.fromMillisecondsSinceEpoch(expired);
    }
  }

  /// _save save data to storage
  Future<void> _save() async {
    if (_data != null && _data!.isNotEmpty) {
      var map = <String, dynamic>{}..addAll(_data!);
      var expired = map[_kAccessTokenExpiredKey];
      if (expired != null) {
        map[_kAccessTokenExpiredKey] = expired.millisecondsSinceEpoch;
      }
      expired = map[_kRefreshTokenExpiredKey];
      if (expired != null) {
        map[_kRefreshTokenExpiredKey] = expired.millisecondsSinceEpoch;
      }
      await preferences.setMap(_kSessionKey, map);
      return;
    }
    await preferences.delete(_kSessionKey);
  }

  /// hasValidAccessToken return true when valid access token is in session
  @visibleForTesting
  bool get hasValidAccessToken {
    final expired = _data![_kAccessTokenExpiredKey];
    if (expired != null && expired.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  /// hasValidRefreshToken return true when valid refresh token is in session
  @visibleForTesting
  bool get hasValidRefreshToken {
    final expired = _data![_kRefreshTokenExpiredKey];
    if (expired != null && expired.isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  /// isLogin return true if login and session is valid, it will refresh access token if expired
  /// ```dart
  /// var valid = await provide.isLogin();
  /// ```
  Future<bool> isLogin() async {
    await _load();
    if (hasValidAccessToken) {
      return true;
    }

    if (onAccessTokenRefresh != null && hasValidRefreshToken) {
      await onAccessTokenRefresh!(_data![_kRefreshTokenKey], this);
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
  /// ```dart
  /// final token = await provide.getAccessToken(context);
  /// ```
  Future<String?> getAccessToken() async {
    if (await isLogin()) {
      return _data![_kAccessTokenKey];
    }
    return null;
  }

  /// login to save token
  /// ```dart
  /// await provide.login(
  ///    accessToken: 'fakeAccessToken',
  ///    accessTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
  ///    refreshToken: 'fakeAccessToken',
  ///    refreshTokenExpired: rExpired,
  ///  );
  /// ```
  Future<void> login({
    required String accessToken,
    required DateTime accessTokenExpired,
    String? refreshToken,
    DateTime? refreshTokenExpired,
    Map<String, dynamic>? extra,
  }) async {
    assert(accessToken.isNotEmpty);
    await _load();
    _data![_kAccessTokenKey] = accessToken;
    _data![_kAccessTokenExpiredKey] = accessTokenExpired;
    _data![_kRefreshTokenKey] = refreshToken;
    _data![_kRefreshTokenExpiredKey] = refreshTokenExpired;
    if (extra != null) {
      _data!.addAll(extra);
    }
    _save();
  }

  /// loginByRefreshToken login by refresh token and refresh access token
  /// ```dart
  /// await session.loginByRefresh(
  ///   accessToken: 'fakeAccessToken2',
  ///   accessTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
  /// );
  /// ```
  Future<void> loginByRefreshToken({
    required String accessToken,
    required DateTime accessTokenExpired,
  }) async {
    assert(accessToken.isNotEmpty);
    await _load();
    _data![_kAccessTokenKey] = accessToken;
    _data![_kAccessTokenExpiredKey] = accessTokenExpired;
    _save();
  }

  /// logout session
  /// ```dart
  /// provide.logout();
  /// ```
  Future<void> logout() async {
    if (onLogout != null) {
      onLogout!();
    }
    _data = {};
    _save();
  }

  /// set value to session
  /// ```dart
  /// await provide.set(context, 'region', 'en');
  /// ```
  Future<void> set(String key, dynamic value) async {
    if (await isLogin()) {
      _data![key] = value;
      await _save();
    }
  }

  /// get value from session
  /// ```dart
  /// final region = await provide.get(context, 'region');
  /// ```
  Future<T?> get<T>(String key) async {
    if (await isLogin()) {
      return _data![key];
    }
    return null;
  }
}
