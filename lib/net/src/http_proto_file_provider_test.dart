// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/sample/sample.dart' as sample;
import 'http_proto_file_provider.dart';

void main() {
  group('[net.http_proto_file_provider]', () {
    test('should return OK', () async {
      final httpProtoFileProvider = HttpProtoFileProvider();
      httpProtoFileProvider.mockDownloader = (String url) async => sample.StringResponse();
      final obj = await httpProtoFileProvider.download<sample.StringResponse>(
        'https://piyuo.com/brand/index.pb',
        () => sample.StringResponse(),
      );
      expect(obj, isA<sample.StringResponse>());
    });

    test('should throw exception when builder is wrong', () async {
      final httpProtoFileProvider = HttpProtoFileProvider();
      httpProtoFileProvider.mockDownloader = (String url) async => sample.Person();
      try {
        await httpProtoFileProvider.download(
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
