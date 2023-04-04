// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/sample/sample.dart' as sample;
import 'http_object_provider.dart';

void main() {
  group('[command.http_object_provider]', () {
    test('should return OK', () async {
      final httpObjectProvider = HttpObjectProvider(mockObjectBuilder: (String url) async => pb.OK());
      final obj = await httpObjectProvider.download<pb.OK>(
        'https://piyuo.com/brand/index.pb',
        () => pb.OK(),
      );
      expect(obj, isA<pb.OK>());
    });

    test('should throw exception when builder is wrong', () async {
      final httpObjectProvider = HttpObjectProvider(
        mockObjectBuilder: (String url) async => sample.StringResponse(),
      );

      try {
        await httpObjectProvider.download(
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
