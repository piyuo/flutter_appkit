// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/pb/pb.dart' as pb;
import 'package:libcli/command/command.dart' as command;
import 'http_file_provider.dart';

void main() {
  group('[cache.http_file_provider]', () {
    test('should return OK', () async {
      final httpFileProvider = HttpFileProvider(
        mockFileBuilder: (String url) async => command.encode(pb.OK()),
      );
      final bytes = await httpFileProvider.getSingleFile('https://mock/mock.pb');
      final obj = command.decode(bytes, () => pb.OK());
      expect(obj is pb.OK, true);
    });

    test('should return file', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final httpFileProvider = HttpFileProvider(
        mockFileBuilder: (String url) async => command.encode(pb.OK()),
      );

      final bytes = await httpFileProvider.getSingleFile('http://starbucks.com');
      expect(bytes, isNotEmpty);
    });
  });
}
