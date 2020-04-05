import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/utils/mail_checker.dart';

void main() {
  setUp(() async {});

  group('[mail_checker]', () {
    test('should suggest correct domain', () async {
      var checker = MailChecker("me@hotwail.com");
      var suggest = checker.suggest();
      expect(suggest.full, "me@hotmail.com");

      var checker2 = MailChecker("me@qql.com");
      var suggest2 = checker2.suggest();
      expect(suggest2.full, "me@qq.com");
    });
  });
}
