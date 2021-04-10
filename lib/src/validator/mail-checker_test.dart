import 'package:flutter_test/flutter_test.dart';
import 'package:libcli/src/validator/mail-checker.dart';

void main() {
  setUp(() async {});

  group('[mail_checker]', () {
    test('should suggest correct domain', () async {
      var suggest = MailChecker(email: "me@hotwail.com").suggest();
      expect(suggest!.full, "me@hotmail.com");

      suggest = MailChecker(email: "me@qql.com").suggest();
      expect(suggest!.full, "me@qq.com");

      suggest = MailChecker(email: "").suggest();
      expect(suggest, null);

      suggest = MailChecker(email: "a").suggest();
      expect(suggest, null);
    });
  });
}
