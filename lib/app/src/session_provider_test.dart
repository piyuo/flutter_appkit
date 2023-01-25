// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'session_provider.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/preferences/preferences.dart' as preferences;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    storage.initForTest({});
  });

  group('[session_provider]', () {
    test('should save/load token', () async {
      final expired = DateTime.now().add(const Duration(seconds: 300));
      final token = Token(
        key: 'key',
        expired: expired,
      );
      await token.save('test');

      final token2 = await Token.load('test');
      expect(token.key, token2!.key);
      expect(token.expired.day, token2.expired.day);
      await preferences.delete('test');
    });

    test('should save/load session', () async {
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      final session = Session(
        accessToken: Token(
          key: 'fakeAccessKey',
          expired: aExpired,
        ),
        refreshToken: Token(
          key: 'fakeRefreshKey',
          expired: rExpired,
        ),
        args: {
          'user': 'user1',
          'img': 'img1',
          'region': 'region1',
        },
      );
      await session.save();

      final session2 = await Session.load();
      expect(session.accessToken.key, session2!.accessToken.key);
      expect(session.accessToken.expired.minute, session2.accessToken.expired.minute);
      expect(session.refreshToken!.key, session2.refreshToken!.key);
      expect(session.refreshToken!.expired.second, session2.refreshToken!.expired.second);
      expect(session['user'], session2['user']);
      expect(session['img'], session2['img']);
      expect(session['region'], session2['region']);
    });

    test('should keep session data', () async {
      final sessionProvider = SessionProvider(loader: (_) async => null);
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      expect(await sessionProvider.session, isNull);
      await sessionProvider.login(Session(
        accessToken: Token(
          key: 'fakeAccessKey',
          expired: aExpired,
        ),
        refreshToken: Token(
          key: 'fakeRefreshKey',
          expired: rExpired,
        ),
        args: {
          'user': 'user1',
          'img': 'img1',
          'region': 'region1',
        },
      ));
      final session = await sessionProvider.session;
      expect(session, isNotNull);
      expect(session!['user'], 'user1');
      expect(session['img'], 'img1');
      expect(session['region'], 'region1');

      final sessionProvider2 = SessionProvider(loader: (_) async => null);
      await sessionProvider2.load();
      final session2 = await sessionProvider2.session;
      expect(session2, isNotNull);
      expect(session2!.isValid, isTrue);
      expect(session2.accessToken.key, 'fakeAccessKey');
      expect(session2.accessToken.isValid, isTrue);
      expect(session2.refreshToken, isNotNull);
      expect(session2.refreshToken!.key, 'fakeRefreshKey');
      expect(session2.refreshToken!.isValid, true);
      expect(session2['user'], 'user1');
      expect(session2['img'], 'img1');
      expect(session2['region'], 'region1');
      sessionProvider2.logout();

      final sessionProvider3 = SessionProvider(loader: (_) async => null);
      expect(await sessionProvider3.session, isNull);
    });

    test('should trigger session loader event', () async {
      String? rKey;
      int refreshCount = 0;
      int loginCount = 0;
      int logoutCount = 0;

      eventbus.listen((event) async {
        if (event is LoginEvent) {
          loginCount++;
        } else if (event is LogoutEvent) {
          logoutCount++;
        }
      });

      final sessionProvider = SessionProvider(
        loader: (Token? refreshToken) async {
          rKey = refreshToken!.key;
          refreshCount++;
          return null;
        },
      );

      await sessionProvider.login(
        Session(
          accessToken: Token(
            key: 'fakeAccessKey',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshToken: Token(
            key: 'fakeRefreshKey',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.session;
      expect(session, isNull);
      expect(refreshCount, 1);
      expect(rKey, 'fakeRefreshKey');
      expect(loginCount, 1);
      expect(logoutCount, 1);
    });

    test('should refresh a new session', () async {
      int refreshCount = 0;
      int loginCount = 0;
      int logoutCount = 0;

      eventbus.listen((event) async {
        if (event is LoginEvent) {
          loginCount++;
        } else if (event is LogoutEvent) {
          logoutCount++;
        }
      });

      final sessionProvider = SessionProvider(
        loader: (Token? refreshToken) async {
          refreshCount++;
          return Session(
            accessToken: Token(
              key: 'fakeAccessKey2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
            refreshToken: refreshToken,
          );
        },
      );

      await sessionProvider.login(
        Session(
          accessToken: Token(
            key: 'fakeAccessKey',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshToken: Token(
            key: 'fakeRefreshKey',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.session;
      expect(session, isNotNull);
      expect(refreshCount, 1);
      expect(loginCount, 1);
      expect(logoutCount, 0);
    });

    test('should refresh new access and refresh token', () async {
      int refreshCount = 0;
      int loginCount = 0;
      int logoutCount = 0;
      eventbus.listen((event) async {
        if (event is LoginEvent) {
          loginCount++;
        } else if (event is LogoutEvent) {
          logoutCount++;
        }
      });

      final sessionProvider = SessionProvider(
        loader: (Token? refreshToken) async {
          refreshCount++;
          return Session(
            accessToken: Token(
              key: 'access2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
            refreshToken: Token(
              key: 'refresh2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
          );
        },
      );
      await sessionProvider.login(
        Session(
          accessToken: Token(
            key: 'access1',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshToken: Token(
            key: 'refresh1',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
        ),
      );
      var session = await sessionProvider.session;
      expect(session, isNotNull);
      expect(session!.refreshToken!.key, 'refresh2');
      expect(refreshCount, 1);
      expect(loginCount, 1);
      expect(logoutCount, 0);
    });
  });
}
