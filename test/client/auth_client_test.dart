import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/client.dart' as client;

void main() {
  client.mockAuth({});
  setUp(() async {});

  group('[auth]', () {
    test('should set/get refresh toekn', () async {
      var refreshToken = await client.getRefreshToken();
      expect(refreshToken, '');

      await client.setRefreshToken('t');
      refreshToken = await client.getRefreshToken();
      expect(refreshToken, 't');

      await client.setRefreshToken(null);
      refreshToken = await client.getRefreshToken();
      expect(refreshToken, '');
    });

    test('should set/get access toekn', () async {
      var accessToken = await client.getAccessToken();
      expect(accessToken, '');

      await client.setAccessToken('t');
      accessToken = await client.getAccessToken();
      expect(accessToken, 't');

      await client.setAccessToken(null);
      accessToken = await client.getAccessToken();
      expect(accessToken, '');
    });

    test('should return empty when access toekn is expire', () async {
      await client.setAccessToken('t');
      var accessToken = await client.getAccessToken();
      expect(accessToken, 't');
      var expired = DateTime.now().add(Duration(hours: -5));
      await client.mockAccessTokenCreateDate(expired);

      accessToken = await client.getAccessToken();
      expect(accessToken, '');
    });
  });
}
