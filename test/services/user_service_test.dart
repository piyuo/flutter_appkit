import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/services.dart' as services;

void main() {
  services.mockAuth({});
  setUp(() async {});

  group('[auth]', () {
    test('should set/get refresh toekn', () async {
      var refreshToken = await services.getRefreshToken();
      expect(refreshToken, '');

      await services.setRefreshToken('t');
      refreshToken = await services.getRefreshToken();
      expect(refreshToken, 't');

      await services.setRefreshToken(null);
      refreshToken = await services.getRefreshToken();
      expect(refreshToken, '');
    });

    test('should set/get access toekn', () async {
      var accessToken = await services.getAccessToken();
      expect(accessToken, '');

      await services.setAccessToken('t');
      accessToken = await services.getAccessToken();
      expect(accessToken, 't');

      await services.setAccessToken(null);
      accessToken = await services.getAccessToken();
      expect(accessToken, '');
    });

    test('should return empty when access toekn is expire', () async {
      await services.setAccessToken('t');
      var accessToken = await services.getAccessToken();
      expect(accessToken, 't');
      var expired = DateTime.now().add(Duration(hours: -5));
      await services.mockAccessTokenCreateDate(expired);

      accessToken = await services.getAccessToken();
      expect(accessToken, '');
    });
  });
}
