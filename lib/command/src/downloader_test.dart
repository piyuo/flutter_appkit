// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'package:libcli/cache/cache.dart' as cache;
import 'downloader.dart';
import 'protobuf.dart';

void main() {
  group('[command.downloader]', () {
    test('should return OK', () async {
      final downloader = Downloader(
        fileProvider: cache.FileProvider(
          fileGetter: (String url) async => encode(pb.OK()),
        ),
      );
      final obj = await downloader.getObject<pb.OK>(
        'https://piyuo.com/brand/index.pb',
        () => pb.OK(),
      );
      expect(obj, isA<pb.OK>());
    });

    test('should throw exception when builder is wrong', () async {
      final downloader = Downloader(
        fileProvider: cache.FileProvider(
          fileGetter: (String url) async => encode(sample.StringResponse()),
        ),
      );

      try {
        await downloader.getObject(
          'https://piyuo.com/brand/index.pb',
          () => pb.Error(),
        );
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<AssertionError>());
        // more expect statements can go here
      }
    });
  });
}
