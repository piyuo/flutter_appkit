// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'session_provider.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/net/net.dart' as net;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    storage.initForTest({});
  });

  group('[session_provider]', () {
    test('should save/load token', () async {
      final expired = DateTime.now().add(const Duration(seconds: 300));
      final token = Token(
        value: 'key',
        expired: expired,
      );
      await token.save('test');

      final token2 = await Token.load('test');
      expect(token.value, token2!.value);
      expect(token.expired.day, token2.expired.day);
      await preferences.remove('test');
    });

    test('should save/load session', () async {
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      final session = Session(
        userId: 'user1',
        accessToken: Token(
          value: 'fakeAccessKey',
          expired: aExpired,
        ),
        refreshToken: Token(
          value: 'fakeRefreshKey',
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
      expect(session.accessToken.value, session2!.accessToken.value);
      expect(session.accessToken.expired.minute, session2.accessToken.expired.minute);
      expect(session.refreshToken!.value, session2.refreshToken!.value);
      expect(session.refreshToken!.expired.second, session2.refreshToken!.expired.second);
      expect(session['user'], session2['user']);
      expect(session['img'], session2['img']);
      expect(session['region'], session2['region']);
      expect(session.userId, 'user1');
    });

    test('should keep session data', () async {
      final sessionProvider = SessionProvider(loader: (_) async => null);
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      expect(await sessionProvider.getValidSession(), isNull);
      await sessionProvider.login(Session(
        userId: 'user1',
        accessToken: Token(
          value: 'fakeAccessKey',
          expired: aExpired,
        ),
        refreshToken: Token(
          value: 'fakeRefreshKey',
          expired: rExpired,
        ),
        args: {
          'user': 'user1',
          'img': 'img1',
          'region': 'region1',
        },
      ));
      final session = await sessionProvider.getValidSession();
      expect(session, isNotNull);
      expect(session!['user'], 'user1');
      expect(session['img'], 'img1');
      expect(session['region'], 'region1');

      final sessionProvider2 = SessionProvider(loader: (_) async => null);
      await sessionProvider2.init();
      final session2 = await sessionProvider2.getValidSession();
      expect(session2, isNotNull);
      expect(session2!.isValid, isTrue);
      expect(session2.accessToken.value, 'fakeAccessKey');
      expect(session2.accessToken.isValid, isTrue);
      expect(session2.refreshToken, isNotNull);
      expect(session2.refreshToken!.value, 'fakeRefreshKey');
      expect(session2.refreshToken!.isValid, true);
      expect(session2['user'], 'user1');
      expect(session2['img'], 'img1');
      expect(session2['region'], 'region1');
      await sessionProvider2.logout();

      final sessionProvider3 = SessionProvider(loader: (_) async => null);
      expect(await sessionProvider3.getValidSession(), isNull);
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
          rKey = refreshToken!.value;
          refreshCount++;
          return null;
        },
      );

      await sessionProvider.login(
        Session(
          userId: 'user1',
          accessToken: Token(
            value: 'fakeAccessKey',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshToken: Token(
            value: 'fakeRefreshKey',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.getValidSession();
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
            userId: 'user1',
            accessToken: Token(
              value: 'fakeAccessKey2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
            refreshToken: refreshToken,
          );
        },
      );

      await sessionProvider.login(
        Session(
          userId: 'user1',
          accessToken: Token(
            value: 'fakeAccessKey',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshToken: Token(
            value: 'fakeRefreshKey',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.getValidSession();
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
            userId: 'user1',
            accessToken: Token(
              value: 'access2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
            refreshToken: Token(
              value: 'refresh2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
          );
        },
      );
      await sessionProvider.login(
        Session(
          userId: 'user1',
          accessToken: Token(
            value: 'access1',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshToken: Token(
            value: 'refresh1',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.getValidSession();
      expect(session, isNotNull);
      expect(session!.refreshToken!.value, 'refresh2');
      expect(refreshCount, 1);
      expect(loginCount, 1);
      expect(logoutCount, 0);
    });

    test('should handle AccessTokenRevokedEvent', () async {
      final sessionProvider = SessionProvider(
        loader: (Token? refreshToken) async => null,
      );
      await sessionProvider.login(
        Session(
          userId: 'user1',
          accessToken: Token(
            value: 'access',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );

      var session = await sessionProvider.getValidSession();
      expect(session, isNotNull);
      await eventbus.broadcast(net.AccessTokenRevokedEvent('invalid'));
      expect(session!.isValid, isFalse);

      var session2 = await sessionProvider.getValidSession();
      expect(session2, isNull);
    });

    test('should handle ForceLogOutEvent', () async {
      final sessionProvider = SessionProvider(
        loader: (Token? refreshToken) async => null,
      );
      await sessionProvider.login(
        Session(
          userId: 'user1',
          accessToken: Token(
            value: 'access',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
          refreshToken: Token(
            value: 'refresh',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );

      var session = await sessionProvider.getValidSession();
      expect(session, isNotNull);
      await eventbus.broadcast(net.ForceLogOutEvent());
      expect(session!.isValid, isFalse);

      var session2 = await sessionProvider.getValidSession();
      expect(session2, isNull);
    });
  });
}
