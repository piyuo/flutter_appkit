// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/net/net.dart' as net;
import 'package:libcli/sample/sample.dart' as sample;
import 'http_file_provider.dart';

void main() {
  group('[cache.http_file_provider]', () {
    test('should return OK', () async {
      final httpFileProvider = HttpFileProvider(
        mockFileBuilder: (String url) async => net.encode(sample.Person()),
      );
      final bytes = await httpFileProvider.getSingleFile('https://mock/mock.pb');
      final obj = net.decode(bytes, () => sample.Person());
      expect(obj is sample.Person, true);
    });

    test('should return file', () async {
      WidgetsFlutterBinding.ensureInitialized();
      final httpFileProvider = HttpFileProvider(
        mockFileBuilder: (String url) async => net.encode(sample.Person()),
      );

      final bytes = await httpFileProvider.getSingleFile('http://starbucks.com');
      expect(bytes, isNotEmpty);
    });
  });
}
