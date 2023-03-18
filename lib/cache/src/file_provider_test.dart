// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/command/command.dart' as command;
import 'file_provider.dart';

void main() {
  group('[cache.file_provider]', () {
    test('should return OK', () async {
      final fileProvider = FileProvider(
        fileGetter: (String url) async => command.encode(pb.OK()),
      );
      final bytes = await fileProvider.getSingleFile('https://mock/mock.pb');
      final obj = command.decode(bytes, () => pb.OK());
      expect(obj is pb.OK, true);
    });

    test('should return file', () async {
      final fileProvider = FileProvider();

      try {
        final bytes = await fileProvider.getSingleFile('http://starbucks.com');
        expect(bytes, isNotEmpty);
      } catch (e) {
        expect(e, isA<AssertionError>());
        // more expect statements can go here
      }
    });
  });
}
