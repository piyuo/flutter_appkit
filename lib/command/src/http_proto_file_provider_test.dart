// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'http_proto_file_provider.dart';

void main() {
  group('[command.http_proto_file_provider]', () {
    test('should return OK', () async {
      final httpProtoFileProvider = HttpProtoFileProvider();
      httpProtoFileProvider.mockDownloader = (String url) async => pb.OK();
      final obj = await httpProtoFileProvider.download<pb.OK>(
        'https://piyuo.com/brand/index.pb',
        () => pb.OK(),
      );
      expect(obj, isA<pb.OK>());
    });

    test('should throw exception when builder is wrong', () async {
      final httpProtoFileProvider = HttpProtoFileProvider();
      httpProtoFileProvider.mockDownloader = (String url) async => sample.StringResponse();
      try {
        await httpProtoFileProvider.download(
          'https://piyuo.com/brand/index.pb',
          () => pb.Error(),
        );
        fail("exception not thrown");
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
