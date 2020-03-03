import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('[http]', () {
    test('should failed on bad url or no internet', () async {
      var url = 'http://notexist';
      try {
        await http.post(url, body: {});
      } on SocketException catch (e) {
        expect(e != null, true);
      }
    });

    test('should failed on timeout', () async {
      var url = 'http://baidu.com';
      try {
        var response =
            await http.post(url, body: {}).timeout(Duration(microseconds: 1));
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      } on TimeoutException catch (e) {
        expect(e != null, true);
      }
    });

    test('should get status code other than 200', () async {
      var url = 'https://google.com';
      var response = await http.post(url, body: {});
      expect(response.statusCode != 200, true);
    });
  });
}
