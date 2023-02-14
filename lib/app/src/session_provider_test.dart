// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/preferences/preferences.dart' as storage;
import 'session_provider.dart';
import 'package:libcli/eventbus/eventbus.dart' as eventbus;
import 'package:libcli/preferences/preferences.dart' as preferences;
import 'package:libcli/command/command.dart' as command;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    storage.initForTest({});
  });

  group('[session_provider]', () {
    test('should save/load token', () async {
      final expired = DateTime.now().add(const Duration(seconds: 300));
      final token = Ticket(
        token: 'key',
        expired: expired,
      );
      await token.save('test');

      final token2 = await Ticket.load('test');
      expect(token.token, token2!.token);
      expect(token.expired.day, token2.expired.day);
      await preferences.remove('test');
    });

    test('should save/load session', () async {
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      final session = Session(
        accessTicket: Ticket(
          token: 'fakeAccessKey',
          expired: aExpired,
        ),
        refreshTicket: Ticket(
          token: 'fakeRefreshKey',
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
      expect(session.accessTicket.token, session2!.accessTicket.token);
      expect(session.accessTicket.expired.minute, session2.accessTicket.expired.minute);
      expect(session.refreshTicket!.token, session2.refreshTicket!.token);
      expect(session.refreshTicket!.expired.second, session2.refreshTicket!.expired.second);
      expect(session['user'], session2['user']);
      expect(session['img'], session2['img']);
      expect(session['region'], session2['region']);
    });

    test('should keep session data', () async {
      final sessionProvider = SessionProvider(loader: (_) async => null);
      final aExpired = DateTime.now().add(const Duration(seconds: 300));
      final rExpired = DateTime.now().add(const Duration(seconds: 100));
      expect(await sessionProvider.getSession(), isNull);
      await sessionProvider.login(Session(
        accessTicket: Ticket(
          token: 'fakeAccessKey',
          expired: aExpired,
        ),
        refreshTicket: Ticket(
          token: 'fakeRefreshKey',
          expired: rExpired,
        ),
        args: {
          'user': 'user1',
          'img': 'img1',
          'region': 'region1',
        },
      ));
      final session = await sessionProvider.getSession();
      expect(session, isNotNull);
      expect(session!['user'], 'user1');
      expect(session['img'], 'img1');
      expect(session['region'], 'region1');

      final sessionProvider2 = SessionProvider(loader: (_) async => null);
      await sessionProvider2.init();
      final session2 = await sessionProvider2.getSession();
      expect(session2, isNotNull);
      expect(session2!.isValid, isTrue);
      expect(session2.accessTicket.token, 'fakeAccessKey');
      expect(session2.accessTicket.isValid, isTrue);
      expect(session2.refreshTicket, isNotNull);
      expect(session2.refreshTicket!.token, 'fakeRefreshKey');
      expect(session2.refreshTicket!.isValid, true);
      expect(session2['user'], 'user1');
      expect(session2['img'], 'img1');
      expect(session2['region'], 'region1');
      sessionProvider2.logout();

      final sessionProvider3 = SessionProvider(loader: (_) async => null);
      expect(await sessionProvider3.getSession(), isNull);
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
        loader: (Ticket? refreshToken) async {
          rKey = refreshToken!.token;
          refreshCount++;
          return null;
        },
      );

      await sessionProvider.login(
        Session(
          accessTicket: Ticket(
            token: 'fakeAccessKey',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshTicket: Ticket(
            token: 'fakeRefreshKey',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.getSession();
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
        loader: (Ticket? refreshToken) async {
          refreshCount++;
          return Session(
            accessTicket: Ticket(
              token: 'fakeAccessKey2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
            refreshTicket: refreshToken,
          );
        },
      );

      await sessionProvider.login(
        Session(
          accessTicket: Ticket(
            token: 'fakeAccessKey',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshTicket: Ticket(
            token: 'fakeRefreshKey',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );
      var session = await sessionProvider.getSession();
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
        loader: (Ticket? refreshToken) async {
          refreshCount++;
          return Session(
            accessTicket: Ticket(
              token: 'access2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
            refreshTicket: Ticket(
              token: 'refresh2',
              expired: DateTime.now().add(const Duration(seconds: 30)),
            ),
          );
        },
      );
      await sessionProvider.login(
        Session(
          accessTicket: Ticket(
            token: 'access1',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
          refreshTicket: Ticket(
            token: 'refresh1',
            expired: DateTime.now().add(const Duration(seconds: -30)),
          ),
        ),
      );
      var session = await sessionProvider.getSession();
      expect(session, isNotNull);
      expect(session!.refreshTicket!.token, 'refresh2');
      expect(refreshCount, 1);
      expect(loginCount, 1);
      expect(logoutCount, 0);
    });

    test('should handle AccessTokenRevokedEvent', () async {
      final sessionProvider = SessionProvider(
        loader: (Ticket? refreshToken) async => null,
      );
      await sessionProvider.login(
        Session(
          accessTicket: Ticket(
            token: 'access',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );

      var session = await sessionProvider.getSession();
      expect(session, isNotNull);
      await eventbus.broadcast(command.AccessTokenRevokedEvent('invalid'));
      expect(session!.isValid, isFalse);

      var session2 = await sessionProvider.getSession();
      expect(session2, isNull);
    });

    test('should handle ForceLogOutEvent', () async {
      final sessionProvider = SessionProvider(
        loader: (Ticket? refreshToken) async => null,
      );
      await sessionProvider.login(
        Session(
          accessTicket: Ticket(
            token: 'access',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
          refreshTicket: Ticket(
            token: 'refresh',
            expired: DateTime.now().add(const Duration(seconds: 30)),
          ),
        ),
      );

      var session = await sessionProvider.getSession();
      expect(session, isNotNull);
      await eventbus.broadcast(command.ForceLogOutEvent());
      expect(session!.isValid, isFalse);

      var session2 = await sessionProvider.getSession();
      expect(session2, isNull);
    });
  });
}
