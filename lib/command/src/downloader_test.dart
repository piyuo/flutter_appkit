// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_io/io.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'downloader.dart';
import 'protobuf.dart';

void main() {
  group('[command_downloader_test]', () {
    test('should return OK', () async {
      final downloader = Downloader(
        fileGetter: (String url, Duration timeout) async => encode(pb.OK()),
      );
      final obj = await downloader.download<pb.OK>(
        'https://piyuo.com/brand/index.pb',
        () => pb.OK(),
      );
      expect(obj is pb.OK, true);
    });

    test('should throw exception when builder is wrong', () async {
      final downloader = Downloader(
        fileGetter: (String url, Duration timeout) async => encode(sample.StringResponse()),
      );

      try {
        await downloader.download(
          'https://piyuo.com/brand/index.pb',
          () => pb.Error(),
        );
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<AssertionError>());
        // more expect statements can go here
      }
    });

    test('should throw socket exception when getFile not found', () async {
      try {
        await getFile('http://not_found/not_found', const Duration(seconds: 1));
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<SocketException>());
      }
    });

    test('should throw timeout exception when getFile timeout', () async {
      try {
        await getFile('http://starbucks.com', const Duration(microseconds: 1));
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<TimeoutException>());
      }
    });
  });
}
