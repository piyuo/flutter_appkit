import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/command.dart' as auth;

void main() {
  auth.mockAuth({});
  setUp(() async {});

  group('[auth]', () {
    test('should set/get refresh toekn', () async {
      var refreshToken = await auth.getRefreshToken();
      expect(refreshToken, '');

      await auth.setRefreshToken('t');
      refreshToken = await auth.getRefreshToken();
      expect(refreshToken, 't');

      await auth.setRefreshToken(null);
      refreshToken = await auth.getRefreshToken();
      expect(refreshToken, '');
    });

    test('should set/get access toekn', () async {
      var accessToken = await auth.getAccessToken();
      expect(accessToken, '');

      await auth.setAccessToken('t');
      accessToken = await auth.getAccessToken();
      expect(accessToken, 't');

      await auth.setAccessToken(null);
      accessToken = await auth.getAccessToken();
      expect(accessToken, '');
    });

    test('should return empty when access toekn is expire', () async {
      await auth.setAccessToken('t');
      var accessToken = await auth.getAccessToken();
      expect(accessToken, 't');
      var expired = DateTime.now().add(Duration(hours: -5));
      await auth.mockAccessTokenCreateDate(expired);

      accessToken = await auth.getAccessToken();
      expect(accessToken, '');
    });
  });
}
