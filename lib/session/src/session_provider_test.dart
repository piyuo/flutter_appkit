// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'session_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    storage.initForTest({});
  });

  group('[session_provider]', () {
    test('should keep session data', () async {
      final provide = SessionProvider();
      final valid = await provide.isLogin();
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      expect(valid, false);
      await provide.login(
        accessToken: 'fakeAccessToken',
        accessTokenExpired: aExpired,
        refreshToken: 'fakeRefreshToken',
        refreshTokenExpired: rExpired,
      );
      final valid2 = await provide.isLogin();
      expect(valid2, true);

      await provide.set('region', 'en');
      final region = await provide.get('region');
      expect(region, 'en');

      final provide2 = SessionProvider();
      expect(await provide2.getAccessToken(), 'fakeAccessToken');
      expect(provide2.hasValidAccessToken, true);
      expect(provide2.hasValidRefreshToken, true);
      expect(await provide2.get('region'), 'en');
      provide.logout();

      final provide3 = SessionProvider();
      expect(await provide3.getAccessToken(), null);
      expect(provide3.hasValidAccessToken, false);
      expect(provide3.hasValidRefreshToken, false);
      expect(await provide3.get('region'), null);
    });

    test('should trigger refresh/login back/logout event', () async {
      String? rToken;
      int refreshCount = 0;
      int backCount = 0;
      int logoutCount = 0;
      final provide = SessionProvider(
        onAccessTokenRefresh: (String refreshToken, _) async {
          rToken = refreshToken;
          refreshCount++;
        },
        onLoginBack: (_) async {
          backCount++;
        },
        onLogout: () async {
          logoutCount++;
        },
      );
      await provide.login(
        accessToken: 'fakeAccessToken',
        accessTokenExpired: DateTime.now().add(const Duration(seconds: -30)),
        refreshToken: 'refreshAccessToken',
        refreshTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
      );
      var valid = await provide.isLogin();
      expect(valid, false);
      expect(refreshCount, 1);
      expect(rToken, 'refreshAccessToken');
      expect(backCount, 1);
      expect(logoutCount, 1);
    });

    test('should refresh success', () async {
      int refreshCount = 0;
      int backCount = 0;
      int logoutCount = 0;
      final provide = SessionProvider(
        onAccessTokenRefresh: (String refreshToken, SessionProvider session) async {
          refreshCount++;
          await session.loginByRefresh(
            accessToken: 'fakeAccessToken2',
            accessTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
          );
        },
        onLoginBack: (SessionProvider session) async {
          backCount++;
        },
        onLogout: () async {
          logoutCount++;
        },
      );
      await provide.login(
        accessToken: 'fakeAccessToken',
        accessTokenExpired: DateTime.now().add(const Duration(seconds: -30)),
        refreshToken: 'refreshAccessToken',
        refreshTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
      );
      var valid = await provide.isLogin();
      expect(valid, true);
      expect(refreshCount, 1);
      expect(backCount, 0);
      expect(logoutCount, 0);
    });

    test('should login back success', () async {
      int refreshCount = 0;
      int backCount = 0;
      int logoutCount = 0;
      final provide = SessionProvider(
        onAccessTokenRefresh: (String refreshToken, SessionProvider session) async {
          refreshCount++;
        },
        onLoginBack: (SessionProvider session) async {
          backCount++;
          await session.login(
            accessToken: 'fakeAccessToken2',
            accessTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
            refreshToken: 'fakeRefreshToken2',
            refreshTokenExpired: DateTime.now().add(const Duration(seconds: 30)),
          );
        },
        onLogout: () async {
          logoutCount++;
        },
      );
      await provide.login(
        accessToken: 'fakeAccessToken',
        accessTokenExpired: DateTime.now().add(const Duration(seconds: -30)),
        refreshToken: 'refreshAccessToken',
        refreshTokenExpired: DateTime.now().add(const Duration(seconds: -30)),
      );
      var valid = await provide.isLogin();
      expect(valid, true);
      expect(refreshCount, 0);
      expect(backCount, 1);
      expect(logoutCount, 0);
    });
  });
}
