// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;

import 'downloader.dart';

void main() {
  group('[net.downloader]', () {
    test('should return OK', () async {
      final downloader = Downloader();
      downloader.mock = (String url) async => sample.StringResponse();
      final obj = await downloader.download<sample.StringResponse>(
        'https://piyuo.com/brand/index.pb',
        () => sample.StringResponse(),
      );
      expect(obj, isA<sample.StringResponse>());
    });

    test('should throw exception when builder is wrong', () async {
      final downloader = Downloader();
      downloader.mock = (String url) async => sample.Person();
      try {
        await downloader.download(
          'https://piyuo.com/brand/index.pb',
          () => sample.StringResponse,
        );
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
