// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'http_proto_file_provider.dart';
import 'package:libcli/common/common.dart' as common;

void main() {
  group('[net.http_proto_file_provider]', () {
    test('should return OK', () async {
      final httpProtoFileProvider = HttpProtoFileProvider();
      httpProtoFileProvider.mockDownloader = (String url) async => common.OK();
      final obj = await httpProtoFileProvider.download<common.OK>(
        'https://piyuo.com/brand/index.pb',
        () => common.OK(),
      );
      expect(obj, isA<common.OK>());
    });

    test('should throw exception when builder is wrong', () async {
      final httpProtoFileProvider = HttpProtoFileProvider();
      httpProtoFileProvider.mockDownloader = (String url) async => sample.StringResponse();
      try {
        await httpProtoFileProvider.download(
          'https://piyuo.com/brand/index.pb',
          () => common.Error(),
        );
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
